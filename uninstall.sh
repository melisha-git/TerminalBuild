#!/bin/bash

# =============================================
# 🧹 Terminal Setup Uninstaller
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
    echo "⚠️  No sudo and not root. Package removal may fail."
    SUDO=""
  fi
fi

# --- Uninstall a component with confirmation ---
confirm_remove() {
  local name="$1"
  read -rp "🗑️  Remove $name? [Y/n]: " answer
  answer="${answer:-Y}"
  [[ "$answer" =~ ^[Yy]$ ]]
}

echo "🧹 Starting component removal..."
echo ""

# =============================================
# 1. eza
# =============================================
echo "📂 eza..."

if command -v eza &>/dev/null || grep -q 'alias .*eza' "$HOME/.zshrc" 2>/dev/null; then
  if confirm_remove "eza"; then
    # Remove binary (could be from cargo or apt)
    if [ -f "$HOME/.cargo/bin/eza" ]; then
      rm -f "$HOME/.cargo/bin/eza"
      echo "✅ eza binary removed from ~/.cargo/bin"
    elif command -v eza &>/dev/null; then
      $SUDO apt remove --purge eza -y -qq 2>/dev/null
    fi
    # Clean aliases from .zshrc
    sed -i '/# --- eza aliases ---/d' "$HOME/.zshrc"
    sed -i '/eza_params=/d' "$HOME/.zshrc"
    sed -i '/alias .*eza/d' "$HOME/.zshrc"
    mark_status "eza" "removed"
  else
    mark_status "eza" "skipped"
  fi
else
  echo "ℹ️  eza is not installed."
  mark_status "eza" "not found"
fi

# =============================================
# 2. fzf
# =============================================
echo ""
echo "🔍 fzf..."

if [ -d "$HOME/.fzf" ] || [ -f "$HOME/.fzf.zsh" ]; then
  if confirm_remove "fzf"; then
    # Run fzf's own uninstaller if available
    if [ -f "$HOME/.fzf/uninstall" ]; then
      "$HOME/.fzf/uninstall"
    fi
    rm -rf "$HOME/.fzf"
    rm -f "$HOME/.fzf.bash" "$HOME/.fzf.zsh"
    # Clean .zshrc
    if [ -f "$HOME/.zshrc" ]; then
      sed -i '/fzf/d' "$HOME/.zshrc"
      sed -i '/alias ff=/d' "$HOME/.zshrc"
    fi
    mark_status "fzf" "removed"
  else
    mark_status "fzf" "skipped"
  fi
else
  echo "ℹ️  fzf is not installed."
  mark_status "fzf" "not found"
fi

# =============================================
# 3. Powerlevel10k
# =============================================
echo ""
echo "🎨 Powerlevel10k..."

if [ -d "$HOME/powerlevel10k" ] || grep -q 'powerlevel10k' "$HOME/.zshrc" 2>/dev/null; then
  if confirm_remove "Powerlevel10k"; then
    rm -rf "$HOME/powerlevel10k"
    rm -f "$HOME/.p10k.zsh"
    sed -i '/powerlevel10k/d' "$HOME/.zshrc"
    mark_status "powerlevel10k" "removed"
  else
    mark_status "powerlevel10k" "skipped"
  fi
else
  echo "ℹ️  Powerlevel10k is not installed."
  mark_status "powerlevel10k" "not found"
fi

# =============================================
# 4. Oh My Zsh
# =============================================
echo ""
echo "🔧 Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
  if confirm_remove "Oh My Zsh"; then
    if [ -f "$HOME/.oh-my-zsh/tools/uninstall.sh" ]; then
      echo "⚙️  Running Oh My Zsh uninstaller..."
      env ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/uninstall.sh" --unattended 2>/dev/null
    else
      rm -rf "$HOME/.oh-my-zsh"
    fi
    rm -f "$HOME/.zshrc.omz-uninstalled-"*
    mark_status "oh-my-zsh" "removed"
  else
    mark_status "oh-my-zsh" "skipped"
  fi
else
  echo "ℹ️  Oh My Zsh is not installed."
  mark_status "oh-my-zsh" "not found"
fi

# =============================================
# Summary
# =============================================
echo ""
echo "==========================================="
echo "  📋 Uninstall Summary"
echo "==========================================="
printf "  %-20s %s\n" "COMPONENT" "STATUS"
echo "  ────────────────────────────────────────"

for name in eza fzf powerlevel10k oh-my-zsh; do
  st="${STATUS[$name]:-unknown}"
  case "$st" in
    "removed")   icon="🟢 Removed"   ;;
    "skipped")   icon="🟡 Skipped"   ;;
    "not found") icon="🔵 Not found" ;;
    *)           icon="⚪ Unknown"   ;;
  esac
  printf "  %-20s %s\n" "$name" "$icon"
done

echo "==========================================="
echo ""
echo "💡 Restart your terminal or run: source ~/.bashrc"