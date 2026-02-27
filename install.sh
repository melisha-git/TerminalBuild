#!/bin/bash

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

# =============================================
echo "🚀 Начинаем установку Oh My Zsh..."

install_pkg git
install_pkg zsh
install_pkg curl

if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "✅ Oh My Zsh уже установлен."
else
  echo "🔧 Устанавливаем Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ""
echo "🎨 Проверка Powerlevel10k..."
if [ ! -d "$HOME/powerlevel10k" ]; then
  echo "⬇️ Загружаем тему Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
else
  echo "✅ Powerlevel10k уже загружена."
fi

if ! grep -Fxq "source ~/powerlevel10k/powerlevel10k.zsh-theme" "$HOME/.zshrc"; then
  echo "➕ Добавляем Powerlevel10k в ~/.zshrc"
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.zshrc"
else
  echo "ℹ️ Строка с Powerlevel10k уже присутствует в ~/.zshrc"
fi

echo ""
echo "🔍 Установка fzf (поиск по файлам)..."
if [ -d "$HOME/.fzf" ]; then
  echo "✅ fzf уже загружен."
else
  echo "⬇️ Загружаем fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

if [ -f "$HOME/.fzf.zsh" ]; then
  echo "✅ fzf уже установлен."
else
  echo "⚙️ Устанавливаем fzf..."
  "$HOME/.fzf/install" --all
fi

if ! grep -q 'alias ff=' "$HOME/.zshrc"; then
  echo "➕ Добавляем алиас ff в ~/.zshrc"
  echo 'alias ff="fzf --style full --preview '\''fzf-preview.sh {}'\'' --bind '\''focus:transform-header:file --brief {}'\''"' >> "$HOME/.zshrc"
fi

echo ""

install_pkg eza

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
  echo "✅ Строки с ls успешно добавлены"
else
  echo "ℹ️ Строки с ls уже присутствуют в ~/.zshrc"
fi

echo ""
echo "✅ Установка завершена! Всё готово к работе 🎉"