<div align="center">

# 🛠️ TerminalBuild

**Set up a beautiful Ubuntu/Debian terminal in under 2 minutes.**

[![Shell](https://img.shields.io/badge/Shell-Bash%2FZsh-4EAA25?style=flat-square&logo=gnubash&logoColor=white)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/melisha-git/TerminalBuild?style=flat-square)](https://github.com/melisha-git/TerminalBuild/commits/main)
[![GitHub Stars](https://img.shields.io/github/stars/melisha-git/TerminalBuild?style=flat-square)](https://github.com/melisha-git/TerminalBuild/stargazers)

One script. Zsh + Oh My Zsh + Powerlevel10k + fzf + eza + 30 VS Code extensions.  
No manual config. Everything is interactive — skip what you don't need.

<!-- 
🔥 TODO: Add a GIF/screenshot here! Record your terminal with `asciinema` or `vhs`:
![demo](assets/demo.gif)
-->

</div>

---

## ⚡ Quick Start

```bash
git clone https://github.com/melisha-git/TerminalBuild.git && cd TerminalBuild && chmod +x install.sh && ./install.sh
```

That's it. The script will guide you through each component interactively.

---

## 📦 What Gets Installed

| Component | What it does |
|-----------|-------------|
| **Oh My Zsh** | Zsh framework with plugins and themes |
| **Powerlevel10k** | Fast, beautiful Zsh prompt |
| **fzf** | Fuzzy finder for files, history, and more |
| **eza** | Modern `ls` replacement with icons and git info |
| **VS Code Extensions** | 30+ extensions for Python, C++, Docker, Remote SSH, etc. |

Every component is optional — the installer asks before each one.

---

## 🧹 Uninstall

```bash
cd TerminalBuild && chmod +x uninstall.sh && ./uninstall.sh
```

Clean removal with per-component confirmation.

---

## 📁 Project Structure

```
TerminalBuild/
├── install.sh                 # Terminal setup (interactive)
├── uninstall.sh               # Clean removal
├── vscode-tools-install.sh    # VS Code extensions
├── vscode-tools-uninstall.sh  # VS Code extensions removal
└── README.md
```

---

## 📋 Install Summary

After running, you get a clear status report:

```
===========================================
  📋 Installation Summary
===========================================
  COMPONENT            STATUS
  ────────────────────────────────────────
  git                  🔵 Already existed
  zsh                  🟢 Installed
  oh-my-zsh            🟢 Installed
  powerlevel10k        🟢 Installed
  fzf                  🟢 Installed
  eza                  🟢 Installed
===========================================
```

---

## 🗺️ Roadmap

- [ ] Interactive TUI menu for selecting packages
- [ ] Self-update via `git pull` and script restart
- [ ] Fedora / Arch support

---

## 🤝 Contributing

PRs and issues are welcome! If you have a favorite tool that should be included — open an issue.

---

## 📄 License

[MIT](LICENSE) — use it, fork it, make it yours.

---

<div align="center">

**If this saved you time — ⭐ the repo!**

Made by [@melisha-git](https://github.com/melisha-git)

</div>
