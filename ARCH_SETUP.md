# Arch Linux Setup Guide
> Complete setup documentation for klythron's Arch Linux + XFCE configuration
> Hardware: Intel 4 Series GPU, Dell P190S Monitor (1280x1024, VGA), Dual boot with Windows

---

## 📋 Table of Contents
1. [Base Installation](#1-base-installation)
2. [WiFi Setup](#2-wifi-setup)
3. [Display & Resolution](#3-display--resolution)
4. [XFCE Desktop](#4-xfce-desktop)
5. [Audio (PipeWire)](#5-audio-pipewire)
6. [Zsh Configuration](#6-zsh-configuration)
7. [Polybar](#7-polybar)
8. [GRUB Theming](#8-grub-theming)
9. [Keyboard Shortcuts](#9-keyboard-shortcuts)
10. [AUR Helper (yay)](#10-aur-helper-yay)
11. [BlackArch Tools](#11-blackarch-tools)
12. [Kali USB Persistence](#12-kali-usb-persistence)

---

## 1. Base Installation

Boot Arch Linux ISO and run:
```bash
archinstall
```

Recommended settings:
- Profile: Minimal
- Desktop: XFCE
- Display Manager: LightDM
- Bootloader: GRUB
- Filesystem: ext4
- User: create user with wheel group

---

## 2. WiFi Setup

```bash
# Connect via NetworkManager
nmcli device wifi connect "NetworkName" password "yourpassword"

# Verify connection
ip a
ping google.com
```

---

## 3. Display & Resolution

> ⚠️ Dell P190S monitor on VGA1 output. The monitor name may show as `VGA1` or `VGA-1` — check with `xrandr` first.

### Check current output name
```bash
xrandr
```

### Apply resolution on login via ~/.xprofile
```bash
nano ~/.xprofile
```

Add:
```bash
xrandr --newmode "1280x1024_60.00" 109.00 1280 1360 1496 1712 1024 1027 1034 1072 +hsync +vsync
xrandr --addmode VGA1 1280x1024_60.00
xrandr --output VGA1 --mode 1280x1024_60.00
```

### Set background color (no wallpaper)
```bash
xsetroot -solid "#0a0a0a"
```

Add to `~/.xprofile`:
```bash
echo 'xsetroot -solid "#0a0a0a"' >> ~/.xprofile
```

### Install required packages
```bash
sudo pacman -S xorg-xrandr xorg-xsetroot xf86-video-intel xf86-video-fbdev xf86-video-vesa
```

---

## 4. XFCE Desktop

### Install XFCE
```bash
sudo pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm --force
```

### Set Zsh as default terminal shell in XFCE
Go to: **XFCE Terminal → Edit → Preferences → General**
- Check "Run a custom command instead of my shell"
- Set command to: `/usr/bin/zsh`

Or via config:
```bash
nano ~/.config/xfce4/terminal/terminalrc
```
Add:
```
CommandArgument=/usr/bin/zsh
RunCustomCommand=TRUE
```

### Plank Dock
```bash
sudo pacman -S plank
```

Settings: Transparent theme, Center alignment, Icon size 30, Icon zoom 141

Fix shadow under dock:
**XFCE Settings → Window Manager Tweaks → Compositor → uncheck "Show shadows under dock windows"**

---

## 5. Audio (PipeWire)

> ⚠️ Do NOT install PulseAudio — use PipeWire only. They conflict.

```bash
# Remove PulseAudio if installed
sudo pacman -R pulseaudio-bluetooth plasma-meta plasma-pa pulseaudio

# Install PipeWire
sudo pacman -S pipewire pipewire-pulse pipewire-audio wireplumber

# Enable and start
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
```

### Test audio
```bash
paplay /usr/share/sounds/freedesktop/stereo/bell.oga
```

---

## 6. Zsh Configuration

### Install Zsh
```bash
sudo pacman -S zsh git
```

### Install plugins
```bash
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

### Clone dotfiles
```bash
git clone https://github.com/sofonyas66/dotfiles.git ~/dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```

### Set Zsh as default shell
```bash
which zsh | sudo tee -a /etc/shells
chsh -s /bin/zsh
```

### Auto-detect distro for update alias
The `.zshrc` includes:
```zsh
if command -v pacman &>/dev/null; then
    alias update='sudo pacman -Syu'
elif command -v apt &>/dev/null; then
    alias update='sudo apt update && sudo apt full-upgrade -y'
fi
```

---

## 7. Polybar

### Install
```bash
sudo pacman -S polybar
```

### Install fonts
```bash
sudo pacman -S ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-nerd-fonts-symbols
```

### Config location
```
~/.config/polybar/config.ini
```

### Key config settings
```ini
[bar/mybar]
monitor = VGA1   # Use VGA1 not VGA-1
```

### Scripts needed
- `~/.config/polybar/polybar.sh` — restart polybar
- `~/.config/polybar/pacupdates.sh` — update counter
- `~/.config/polybar/logout.sh` — session logout

### Start polybar
```bash
~/.config/polybar/polybar.sh
```

---

## 8. GRUB Theming

### Install Matrix Morpheus theme
```bash
git clone https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme
cd Matrix-Morpheus-GRUB-Theme
chmod +x install.sh
sudo ./install.sh
```

### Fix theme for 1280x1024 monitor
```bash
sudo nano /boot/grub/themes/Matrix/theme.txt
```

Change:
```
icon_width = 1920
icon_height = 1080
item_height = 1080
```

To:
```
icon_width = 640
icon_height = 1024
item_height = 1024
```

### GRUB config settings
```bash
sudo nano /etc/default/grub
```

```
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_GFXMODE=1280x1024
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_OS_PROBER=false
GRUB_THEME=/boot/grub/themes/Matrix/theme.txt
GRUB_DISABLE_SUBMENU=y
GRUB_DISABLE_RECOVERY=true
```

### Detect Windows dual boot
```bash
sudo pacman -S os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 9. Keyboard Shortcuts

Go to **XFCE Settings → Keyboard → Application Shortcuts** and add:

| Shortcut | Command |
|----------|---------|
| `XF86AudioRaiseVolume` | `pactl set-sink-volume @DEFAULT_SINK@ +5%` |
| `XF86AudioLowerVolume` | `pactl set-sink-volume @DEFAULT_SINK@ -5%` |
| `XF86AudioMute` | `pactl set-sink-mute @DEFAULT_SINK@ toggle` |
| `XF86AudioPlay` | `playerctl play-pause` |
| `XF86AudioNext` | `playerctl next` |
| `XF86AudioPrev` | `playerctl previous` |
| `XF86AudioMedia` | `firefox --new-window open.spotify.com` |

### Install playerctl
```bash
sudo pacman -S playerctl
```

---

## 10. AUR Helper (yay)

```bash
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

---

## 11. BlackArch Tools

```bash
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

# Install common tools
sudo pacman -S nmap netdiscover sqlmap nikto
```

> ⚠️ Only use on networks/systems you own or have permission to test.

---

## 12. Kali USB Persistence (Ventoy)

### Install Ventoy on USB
```bash
sudo pacman -S ventoy
sudo ventoy -i /dev/sdX   # Replace sdX with your USB drive
```

### Copy Kali ISO
```bash
cp kali-linux-2025.4-live-amd64.iso /run/media/$USER/Ventoy/IOS/
```

### Create persistence image (20GB)
```bash
cd /run/media/$USER/Ventoy/
sudo dd if=/dev/zero of=kali-persistence.img bs=1M count=20480
sudo mkfs.ext4 -L persistence kali-persistence.img
```

### Create Ventoy persistence config
```bash
mkdir -p /run/media/$USER/Ventoy/ventoy
nano /run/media/$USER/Ventoy/ventoy/ventoy.json
```

Add:
```json
{
    "persistence": [
        {
            "image": "/IOS/kali-linux-2025.4-live-amd64.iso",
            "backend": "/kali-persistence.img"
        }
    ]
}
```

### Add persistence.conf inside image
Boot into Kali without persistence, then:
```bash
sudo mkdir /mnt/persist
sudo mount -o loop /path/to/kali-persistence.img /mnt/persist
echo "/ union" | sudo tee /mnt/persist/persistence.conf
sudo umount /mnt/persist
```

### Boot with persistence
1. Select Kali ISO from Ventoy menu
2. Select **"Boot with /kali-persistence.img"**
3. From Kali menu select **"Live system with USB persistence"**

---

## 🔧 Useful Commands Reference

```bash
# Check display output name
xrandr

# Restart Polybar
~/.config/polybar/polybar.sh

# Start Plank
pkill plank && plank &

# Check audio
pactl list sinks short

# Check WiFi
nmcli device wifi list
nmcli device wifi connect "Name" password "pass"

# System update
sudo pacman -Syu

# AUR update
yay -Syu

# Update GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 🖥️ System Info

| Component | Details |
|-----------|---------|
| GPU | Intel 4 Series Chipset (Q45/Q43) |
| Monitor | Dell P190S, 1280x1024, VGA |
| Display Output | VGA1 |
| Shell | Zsh |
| Desktop | XFCE |
| Display Manager | LightDM |
| Audio | PipeWire |
| Bootloader | GRUB |

---

Maintained by [sofonyas66](https://github.com/sofonyas66)
