#!/bin/bash

# =============================================
# 🧹 VS Code + Extensions Uninstaller
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

# --- Check if VS Code is present ---
if ! command -v code &>/dev/null; then
  echo "ℹ️  VS Code is not installed. Nothing to do."
  exit 0
fi

# =============================================
# 1. Remove Extensions
# =============================================
echo "🧹 VS Code Uninstaller"
echo ""

EXTENSIONS=(
  aaron-bond.better-comments
  almenon.arepl
  ash-blade.postgresql-hacker-helper
  eamodio.gitlens
  esbenp.prettier-vscode
  github.copilot-chat
  johnpapa.vscode-peacock
  kevinrose.vsc-python-indent
  ms-azuretools.vscode-containers
  ms-azuretools.vscode-docker
  ms-python.debugpy
  ms-python.python
  ms-python.vscode-pylance
  ms-python.vscode-python-envs
  ms-vscode-remote.remote-containers
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-ssh-edit
  ms-vscode.cmake-tools
  ms-vscode.cpp-devtools
  ms-vscode.cpptools
  ms-vscode.cpptools-extension-pack
  ms-vscode.cpptools-themes
  ms-vscode.makefile-tools
  ms-vscode.remote-explorer
  mumarshahbaz.als
  nstechbytes.html-view
  oderwat.indent-rainbow
  pkief.material-icon-theme
  quicktype.quicktype
  tonybaloney.vscode-pets
  wolfieshorizon.python-auto-venv
)

read -rp "🧩 Remove all listed extensions? [Y/n]: " answer
answer="${answer:-Y}"

if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo ""
  INSTALLED=$(code --list-extensions 2>/dev/null)

  for ext in "${EXTENSIONS[@]}"; do
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    if echo "$INSTALLED" | tr '[:upper:]' '[:lower:]' | grep -qx "$ext_lower"; then
      if code --uninstall-extension "$ext" 2>/dev/null; then
        echo "  🟢 $ext — removed"
        mark_status "$ext" "removed"
      else
        echo "  🔴 $ext — failed"
        mark_status "$ext" "failed"
      fi
    else
      echo "  ⚪ $ext — not installed"
      mark_status "$ext" "not found"
    fi
  done
else
  echo "⏭️  Skipping extension removal."
  for ext in "${EXTENSIONS[@]}"; do
    mark_status "$ext" "skipped"
  done
fi

# =============================================
# 2. Remove VS Code
# =============================================
echo ""
read -rp "🗑️  Also remove VS Code itself? [y/N]: " answer
answer="${answer:-N}"

if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "⬇️  Removing VS Code..."
  if $SUDO apt remove --purge code -y -qq 2>/dev/null; then
    # Clean up repo and key
    $SUDO rm -f /etc/apt/sources.list.d/vscode.list
    $SUDO rm -f /etc/apt/keyrings/packages.microsoft.gpg
    # Clean up user data (optional)
    read -rp "🗂️  Also remove VS Code settings and data? [y/N]: " data_answer
    data_answer="${data_answer:-N}"
    if [[ "$data_answer" =~ ^[Yy]$ ]]; then
      rm -rf "$HOME/.config/Code"
      rm -rf "$HOME/.vscode"
      mark_status "vscode" "removed + data cleaned"
    else
      mark_status "vscode" "removed"
    fi
  else
    mark_status "vscode" "failed"
  fi
else
  echo "⏭️  Keeping VS Code."
  mark_status "vscode" "kept"
fi

# =============================================
# Summary
# =============================================
echo ""
echo "==========================================="
echo "  📋 Uninstall Summary"
echo "==========================================="

# VS Code status
st="${STATUS[vscode]:-kept}"
case "$st" in
  "removed")              icon="🟢 Removed"              ;;
  "removed + data cleaned") icon="🟢 Removed + data cleaned" ;;
  "kept")                 icon="🔵 Kept"                 ;;
  "failed")               icon="🔴 Failed"               ;;
  *)                      icon="⚪ Unknown"              ;;
esac
printf "\n  %-40s %s\n" "VS Code" "$icon"

# Extensions summary
ext_removed=0
ext_notfound=0
ext_failed=0
ext_skipped=0
failed_list=()

for ext in "${EXTENSIONS[@]}"; do
  st="${STATUS[$ext]:-unknown}"
  case "$st" in
    "removed")   ((ext_removed++))  ;;
    "not found") ((ext_notfound++)) ;;
    "failed")    ((ext_failed++)); failed_list+=("$ext") ;;
    "skipped")   ((ext_skipped++)) ;;
  esac
done

echo ""
echo "  Extensions:"
echo "  ────────────────────────────────────────"
printf "  🟢 Removed:         %d\n" "$ext_removed"
printf "  ⚪ Not installed:   %d\n" "$ext_notfound"
printf "  🟡 Skipped:         %d\n" "$ext_skipped"
printf "  🔴 Failed:          %d\n" "$ext_failed"

if [ ${#failed_list[@]} -gt 0 ]; then
  echo ""
  echo "  Failed extensions:"
  for f in "${failed_list[@]}"; do
    echo "    ❌ $f"
  done
fi

echo ""
echo "==========================================="
echo ""
echo "✅ Done! 🎉"