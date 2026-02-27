#!/bin/bash

# =============================================
# 🚀 Скрипт настройки терминала
# Oh My Zsh + Powerlevel10k + fzf + eza
# =============================================

# --- Определяем, нужен ли sudo ---
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  if command -v sudo &>/dev/null; then
    SUDO="sudo"
  else
    echo "⚠️  Нет sudo и вы не root. Установка пакетов может не сработать."
    SUDO=""
  fi
fi

# --- Функция для установки пакета с подтверждением ---
install_pkg() {
  local pkg="$1"
  if command -v "$pkg" &>/dev/null; then
    echo "✅ $pkg уже установлен."
    return 0
  fi
  read -rp "📦 $pkg не найден. Установить? [Y/n]: " answer
  answer="${answer:-Y}"
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    $SUDO apt install "$pkg" -y -qq
  else
    echo "⏭️  Пропускаем $pkg."
    return 1
  fi
}

# --- Функция для установки eza через cargo/rustup ---
install_eza() {
  if command -v eza &>/dev/null; then
    echo "✅ eza уже установлена."
    return 0
  fi

  read -rp "📦 eza не найдена. Установить через cargo? [Y/n]: " answer
  answer="${answer:-Y}"
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "⏭️  Пропускаем eza."
    return 1
  fi

  # Проверяем наличие cargo, если нет — ставим rustup
  if ! command -v cargo &>/dev/null; then
    echo "🦀 cargo не найден. Устанавливаем Rust через rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi

  echo "⚙️  Собираем eza через cargo (это может занять пару минут)..."
  cargo install eza
}

# =============================================
# 1. Базовые пакеты
# =============================================
echo "🚀 Начинаем настройку терминала..."
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
  echo "✅ Oh My Zsh уже установлен."
else
  echo "⬇️ Устанавливаем Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# =============================================
# 3. Powerlevel10k
# =============================================
echo ""
echo "🎨 Powerlevel10k..."

if [ -d "$HOME/powerlevel10k" ]; then
  echo "✅ Powerlevel10k уже загружена."
else
  echo "⬇️ Загружаем тему Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
fi

if ! grep -Fxq "source ~/powerlevel10k/powerlevel10k.zsh-theme" "$HOME/.zshrc"; then
  echo "➕ Добавляем Powerlevel10k в ~/.zshrc"
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.zshrc"
else
  echo "ℹ️  Powerlevel10k уже в ~/.zshrc"
fi

# =============================================
# 4. fzf
# =============================================
echo ""
echo "🔍 fzf..."

if [ -d "$HOME/.fzf" ]; then
  echo "✅ fzf уже загружен."
else
  echo "⬇️ Загружаем fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

if [ -f "$HOME/.fzf.zsh" ]; then
  echo "✅ fzf уже установлен."
else
  echo "⚙️  Устанавливаем fzf..."
  "$HOME/.fzf/install" --all
fi

if ! grep -q 'alias ff=' "$HOME/.zshrc"; then
  echo "➕ Добавляем алиас ff в ~/.zshrc"
  echo 'alias ff="fzf --style full --preview '\''fzf-preview.sh {}'\'' --bind '\''focus:transform-header:file --brief {}'\''"' >> "$HOME/.zshrc"
fi

# =============================================
# 5. eza
# =============================================
echo ""
echo "📂 eza..."

install_eza

if ! grep -q 'alias ls="eza' "$HOME/.zshrc"; then
  cat >> "$HOME/.zshrc" << 'EOF'

# --- eza aliases ---
eza_params="--icons --group-directories-first"
alias ls="eza $eza_params"
alias l="eza --git-ignore $eza_params"
alias ll="eza --all --header --long $eza_params"
alias llm="eza --all --header --long --sort=modified $eza_params"
alias la="eza -lbhHigUmuSa"
alias lx="eza -lbhHigUmuSa@"
alias lt="eza --tree $eza_params"
alias tree="eza --tree $eza_params"
EOF
  echo "✅ Алиасы eza добавлены в ~/.zshrc"
else
  echo "ℹ️  Алиасы eza уже в ~/.zshrc"
fi

# =============================================
echo ""
echo "✅ Установка завершена! Всё готово к работе 🎉"
echo "💡 Выполните: source ~/.zshrc  (или перезапустите терминал)"