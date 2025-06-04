#!/bin/bash

echo "🚀 Начинаем установку Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh уже установлен."
else
    echo "🔧 Устанавливаем Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
echo "📁 Копируем конфигурацию Ghostty..."
cp ghostty_config "$HOME/.config/ghostty/config"

echo ""
echo "✅ Установка завершена! Всё готово к работе 🎉"