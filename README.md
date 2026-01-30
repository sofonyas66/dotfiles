# 🦜 Parrot OS Dotfiles (Zsh Config)

A high-performance, lightweight Zsh configuration optimized for **Parrot OS**. This setup focuses on speed, security, and developer productivity without the bloat of heavy frameworks.

## ✨ Features
- **Intelligent Prompt:** Color-coded for User/Root and displays current Git branch.
- **Auto-Suggestions:** Fish-like "ghost" text suggestions based on your history.
- **Syntax Highlighting:** Real-time feedback (Green for valid commands, Red for errors).
- **Pro Aliases:** Shortcuts for system updates, networking, and safe file management.
- **Infinite History:** Shared history across all open terminal windows.

## 🛠️ Prerequisites
Before installing, ensure you have Zsh installed:
```bash
sudo apt update && sudo apt install zsh git -y

🚀 Installation
1. Clone the plugins

This config relies on two essential plugins. Run these commands to download them:
Bash

mkdir -p ~/.zsh
git clone [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) ~/.zsh/zsh-autosuggestions
git clone [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) ~/.zsh/zsh-syntax-highlighting

2. Apply the configuration

Clone this repository and link the config file:
Bash

git clone [https://github.com/sofonyas66/dotfiles.git](https://github.com/sofonyas66/dotfiles.git) ~/dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc

3. Set Zsh as default

Change your default shell and restart your terminal:
Bash

sudo chsh -s $(which zsh) $USER

⌨️ Useful Shortcuts

    .. , ... , .... : Fast directory navigation.

    update : Full Parrot OS system update and upgrade.

    reload : Instantly apply changes made to .zshrc.

    myip : Quickly check your public IP address.

    ports : See all active listening network ports.

Maintained by sofonyas66
