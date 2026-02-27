# 🛠️ TerminalBuild

TerminalBuild is a collection of scripts for quick terminal environment and Visual Studio Code setup. The scripts automatically install/remove useful utilities, configure convenient aliases, and make your terminal experience more comfortable.

---

## Prerequisites

Before installation, make sure you have the following:

1. Update packages and install git:
```bash
sudo apt update
sudo apt install git -y
```

2. (Optional) Install Visual Studio Code:
```bash
sudo apt install code
```

> **Note:** If you're running as root, VS Code commands require `--no-sandbox` flag. The scripts handle this automatically.

---

## ⚙️ Installation

1. Clone the repository:
```bash
git clone https://github.com/melisha-git/TerminalBuild.git
```

2. Run the setup:
```bash
cd TerminalBuild
chmod +x install.sh vscode-tools-install.sh
./install.sh
./vscode-tools-install.sh  # (optional)
exec zsh  # or: source ~/.zshrc
```

Each script will ask for confirmation before installing any component — nothing is forced.

---

## 🧹 Uninstallation

To remove installed components:

```bash
cd TerminalBuild
chmod +x uninstall.sh vscode-tools-uninstall.sh
./uninstall.sh
./vscode-tools-uninstall.sh  # (optional)
```

Each component can be skipped individually during removal.

---

## 📦 What's Included

| Component | Description |
|---|---|
| **Oh My Zsh** | Zsh configuration framework |
| **Powerlevel10k** | Fast and customizable Zsh theme |
| **fzf** | Fuzzy file finder with preview |
| **eza** | Modern replacement for `ls` with icons and git support |
| **VS Code Extensions** | 30+ extensions for Python, C++, Docker, Remote SSH, and more |

---

## 📁 Project Structure

```
TerminalBuild/
├── install.sh                 # Terminal utilities installer
├── uninstall.sh               # Terminal utilities uninstaller
├── vscode-tools-install.sh    # VS Code + extensions installer
├── vscode-tools-uninstall.sh  # VS Code + extensions uninstaller
└── README.md                  # Documentation
```

---

## 📋 Summary Output

Both install and uninstall scripts display a summary table at the end:

```
===========================================
  📋 Installation Summary
===========================================
  COMPONENT            STATUS
  ────────────────────────────────────────
  git                  🔵 Already existed
  curl                 🔵 Already existed
  zsh                  🟢 Installed
  oh-my-zsh            🟢 Installed
  powerlevel10k        🟢 Installed
  fzf                  🟢 Installed
  build-essential      🔵 Already existed
  eza                  🟢 Installed
===========================================
```

---

## 🗺️ Roadmap

- [ ] Interactive GUI menu for selecting packages
- [ ] Self-update via `git pull` and script restart

---

## Author

[**@melisha-git**](https://github.com/melisha-git)

Pull Requests and Issues are welcome!