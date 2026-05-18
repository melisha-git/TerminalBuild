#!/bin/bash

# =============================================
# 🚀 Terminal Setup Script
# Oh My Zsh + Powerlevel10k + fzf + eza
# =============================================

# --- Status tracking ---
declare -A STATUS

mark_status() {
  local name="$1"
  local status="$2"
  STATUS["$name"]="$status"
}

# --- Determine if sudo is needed ---
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  if command -v sudo &>/dev/null; then
    SUDO="sudo"
  else
    echo "⚠️  No sudo and not root. Package installation may fail."
    SUDO=""
  fi
fi

# --- Install a package with confirmation ---
install_pkg() {
  local pkg="$1"
  if command -v "$pkg" &>/dev/null; then
    echo "✅ $pkg is already installed."
    mark_status "$pkg" "already installed"
    return 0
  fi
  read -rp "📦 $pkg not found. Install? [Y/n]: " answer
  answer="${answer:-Y}"
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    if $SUDO apt install "$pkg" -y -qq; then
      mark_status "$pkg" "installed"
    else
      mark_status "$pkg" "failed"
    fi
  else
    echo "⏭️  Skipping $pkg."
    mark_status "$pkg" "skipped"
    return 1
  fi
}

# --- Install eza via cargo/rustup ---
install_eza() {
  if command -v eza &>/dev/null; then
    echo "✅ eza is already installed."
    mark_status "eza" "already installed"
    return 0
  fi

  read -rp "📦 eza not found. Install via cargo? [Y/n]: " answer
  answer="${answer:-Y}"
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "⏭️  Skipping eza."
    mark_status "eza" "skipped"
    return 1
  fi

  # Install rustup if cargo is missing
  if ! command -v cargo &>/dev/null; then
    echo "🦀 cargo not found. Installing Rust via rustup..."
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
      source "$HOME/.cargo/env"
    else
      mark_status "eza" "failed"
      return 1
    fi
  fi

  echo "⚙️  Building eza via cargo (this may take a couple of minutes)..."
  if cargo install eza; then
    mark_status "eza" "installed"
  else
    mark_status "eza" "failed"
  fi
}

# =============================================
# 1. Base packages
# =============================================
echo "🚀 Starting terminal setup..."
echo ""

install_pkg git
install_pkg curl
install_pkg zsh

# =============================================
# 2. Oh My Zsh
# =============================================
echo ""
echo "🔧 Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "✅ Oh My Zsh is already installed."
  mark_status "oh-my-zsh" "already installed"
else
  echo "⬇️ Installing Oh My Zsh..."
  if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
    mark_status "oh-my-zsh" "installed"
  else
    mark_status "oh-my-zsh" "failed"
  fi
fi

# =============================================
# 4. fzf
# =============================================
echo ""
echo "🔍 fzf..."

if [ -d "$HOME/.fzf" ]; then
  echo "✅ fzf is already downloaded."
else
  echo "⬇️ Downloading fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

if [ -f "$HOME/.fzf.zsh" ]; then
  echo "✅ fzf is already installed."
  mark_status "fzf" "already installed"
else
  echo "⚙️  Installing fzf..."
  if "$HOME/.fzf/install" --all; then
    mark_status "fzf" "installed"
  else
    mark_status "fzf" "failed"
  fi
fi

if ! grep -q 'alias ff=' "$HOME/.zshrc"; then
  echo "➕ Adding ff alias to ~/.zshrc"
  echo 'alias ff="fzf --style full --preview '\''fzf-preview.sh {}'\'' --bind '\''focus:transform-header:file --brief {}'\''"' >> "$HOME/.zshrc"
fi

# =============================================
# 5. eza (requires build tools and cargo)
# =============================================
echo ""
echo "📂 eza..."

install_pkg build-essential
install_eza

if ! grep -q 'alias ls="eza' "$HOME/.zshrc"; then
  cat >> "$HOME/.zshrc" << 'EOF'

# --- eza aliases ---
eza_params="--icons=never"
alias ls="eza $eza_params"
alias l="eza --git-ignore $eza_params"
alias ll="eza --all --header --long $eza_params"
alias llm="eza --all --header --long --sort=modified $eza_params"
alias la="eza -lbhHigUmuSa"
alias lx="eza -lbhHigUmuSa@"
alias lt="eza --tree $eza_params"
alias tree="eza --tree $eza_params"
EOF
  echo "✅ eza aliases added to ~/.zshrc"
else
  echo "ℹ️  eza aliases are already in ~/.zshrc"
fi

# =============================================
# Inputrc (history search with arrow keys)
# =============================================
echo ""
echo "⌨️  Inputrc..."

if [ -f "$HOME/.inputrc" ] && grep -q 'history-search-backward' "$HOME/.inputrc"; then
  echo "✅ History search bindings already configured."
  mark_status "inputrc" "already installed"
else
  cat >> "$HOME/.inputrc" << 'EOF'
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF
  echo "✅ Arrow key history search added to ~/.inputrc"
  mark_status "inputrc" "installed"
fi

# =============================================
# Summary
# =============================================
echo ""
echo "==========================================="
echo "  📋 Installation Summary"
echo "==========================================="
printf "  %-20s %s\n" "COMPONENT" "STATUS"
echo "  ────────────────────────────────────────"

for name in git curl zsh oh-my-zsh fzf build-essential eza; do
  st="${STATUS[$name]:-unknown}"
  case "$st" in
    "installed")         icon="🟢 Installed"       ;;
    "already installed") icon="🔵 Already existed"  ;;
    "skipped")           icon="🟡 Skipped"          ;;
    "failed")            icon="🔴 Failed"           ;;
    *)                   icon="⚪ Unknown"          ;;
  esac
  printf "  %-20s %s\n" "$name" "$icon"
done

echo "==========================================="
echo ""
echo "💡 Run: zsh; source ~/.zshrc  (or restart your terminal)"
