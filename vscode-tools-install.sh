#!/bin/bash

# =============================================
# 🛠️ VS Code + Extensions Installer
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

# =============================================
# 1. Install VS Code
# =============================================
echo "🚀 VS Code Setup..."
echo ""

if command -v code &>/dev/null; then
  echo "✅ VS Code is already installed."
  mark_status "vscode" "already installed"
else
  read -rp "📦 VS Code not found. Install? [Y/n]: " answer
  answer="${answer:-Y}"
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "⬇️  Installing VS Code..."

    # Install dependencies
    $SUDO apt update -qq
    $SUDO apt install -y -qq wget gpg apt-transport-https

    # Add Microsoft GPG key
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    $SUDO install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    rm -f /tmp/packages.microsoft.gpg

    # Add VS Code repository
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
      | $SUDO tee /etc/apt/sources.list.d/vscode.list > /dev/null

    # Install
    $SUDO apt update -qq
    if $SUDO apt install -y -qq code; then
      mark_status "vscode" "installed"
    else
      mark_status "vscode" "failed"
      echo "🔴 VS Code installation failed. Skipping extensions."
      exit 1
    fi
  else
    echo "⏭️  Skipping VS Code."
    mark_status "vscode" "skipped"
    exit 0
  fi
fi

# =============================================
# 2. Install Extensions
# =============================================
echo ""
echo "🧩 Installing extensions..."
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

# Get already installed extensions once
INSTALLED=$(code --list-extensions 2>/dev/null)

for ext in "${EXTENSIONS[@]}"; do
  ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

  if echo "$INSTALLED" | tr '[:upper:]' '[:lower:]' | grep -qx "$ext_lower"; then
    echo "  ✅ $ext — already installed"
    mark_status "$ext" "already installed"
  else
    if code --install-extension "$ext" --force 2>/dev/null; then
      echo "  🟢 $ext — installed"
      mark_status "$ext" "installed"
    else
      echo "  🔴 $ext — failed"
      mark_status "$ext" "failed"
    fi
  fi
done

# =============================================
# Summary
# =============================================
echo ""
echo "==========================================="
echo "  📋 Installation Summary"
echo "==========================================="

# VS Code status
st="${STATUS[vscode]:-unknown}"
case "$st" in
  "installed")         icon="🟢 Installed"      ;;
  "already installed") icon="🔵 Already existed" ;;
  "skipped")           icon="🟡 Skipped"         ;;
  "failed")            icon="🔴 Failed"          ;;
  *)                   icon="⚪ Unknown"         ;;
esac
printf "\n  %-40s %s\n" "VS Code" "$icon"

# Extensions summary
ext_installed=0
ext_existed=0
ext_failed=0
failed_list=()

for ext in "${EXTENSIONS[@]}"; do
  st="${STATUS[$ext]:-unknown}"
  case "$st" in
    "installed")         ((ext_installed++)) ;;
    "already installed") ((ext_existed++))   ;;
    "failed")            ((ext_failed++)); failed_list+=("$ext") ;;
  esac
done

echo ""
echo "  Extensions:"
echo "  ────────────────────────────────────────"
printf "  🟢 Installed:       %d\n" "$ext_installed"
printf "  🔵 Already existed: %d\n" "$ext_existed"
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