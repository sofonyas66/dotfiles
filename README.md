# Dotfiles — Zsh Config
A high-performance, lightweight Zsh configuration optimized for **Parrot OS** and **Arch Linux**. This setup focuses on speed, security, and developer productivity without the bloat of heavy frameworks.

---

## ✨ Features

- **Intelligent Prompt** — Color-coded for User/Root and displays current Git branch.
- **Auto-Suggestions** — Fish-like "ghost" text suggestions based on your history.
- **Syntax Highlighting** — Real-time feedback (Green for valid commands, Red for errors).
- **Pro Aliases** — Shortcuts for system updates, networking, and safe file management.
- **Infinite History** — Shared history across all open terminal windows.
- **Multi-distro Support** — Works on both Parrot OS (apt) and Arch Linux (pacman).

---

## 🛠️ Prerequisites

### Parrot OS
```bash
sudo apt update && sudo apt install zsh git -y
```

### Arch Linux
```bash
sudo pacman -S zsh git
```

---

## 🚀 Installation

### 1. Clone the plugins
```bash
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

### 2. Apply the configuration
```bash
git clone https://github.com/sofonyas66/dotfiles.git ~/dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```

### 3. Set Zsh as default
```bash
chsh -s $(which zsh)
```

Then restart your terminal.

---

## ⌨️ Useful Shortcuts

| Alias | Description |
|-------|-------------|
| `..` , `...` , `....` | Fast directory navigation |
| `update` | Full system update (auto-detects distro) |
| `reload` | Instantly apply changes made to `.zshrc` |
| `myip` | Quickly check your public IP address |
| `ports` | See all active listening network ports |

---

## 🐧 Distro Detection

The config automatically detects your distro and uses the correct package manager:

```zsh
if command -v pacman &>/dev/null; then
    alias update='sudo pacman -Syu'
elif command -v apt &>/dev/null; then
    alias update='sudo apt update && sudo apt full-upgrade -y'
fi
```

No manual changes needed — just install and go.

---

## 📁 File Structure

```
dotfiles/
└── .zshrc        # Main Zsh configuration
```

---

## 🖥️ Tested On

- ✅ Parrot OS (Security Edition)
- ✅ Arch Linux + XFCE

---

Maintained by [sofonyas66](https://github.com/sofonyas66)