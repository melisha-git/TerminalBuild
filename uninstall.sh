#!/bin/bash

echo "🧹 Начинаем удаление компонентов..."

echo ""
echo "🗑️ Удаление fzf..."

# Удаление директории fzf
if [ -d "$HOME/.fzf" ]; then
    rm -rf "$HOME/.fzf"
    echo "✅ Директория ~/.fzf успешно удалена."
else
    echo "ℹ️ Директория ~/.fzf не найдена."
fi

# Удаление конфигурационных файлов fzf
[ -f "$HOME/.fzf.bash" ] && rm -f "$HOME/.fzf.bash"
[ -f "$HOME/.fzf.zsh" ] && rm -f "$HOME/.fzf.zsh"

# Удаление строк, связанных с fzf, из .zshrc
if [ -f "$HOME/.zshrc" ]; then
    sed -i '/fzf/d' "$HOME/.zshrc"
    sed -i '/\[ -f ~/.fzf.bash \] && source ~/.fzf.bash/d' "$HOME/.zshrc" 2>/dev/null
    sed -i '/\[ -f ~/.fzf.zsh \] && source ~/.fzf.zsh/d' "$HOME/.zshrc" 2>/dev/null
    echo "✅ Строки fzf удалены из ~/.zshrc."
else
    echo "⚠️ Файл .zshrc не найден."
fi

echo ""
echo "🎨 Удаление Powerlevel10k..."

if [ -d "$HOME/powerlevel10k" ]; then
    rm -rf "$HOME/powerlevel10k"
    echo "✅ Директория ~/powerlevel10k удалена."
else
    echo "ℹ️ Директория ~/powerlevel10k не найдена."
fi

if grep -Fxq "source ~/powerlevel10k/powerlevel10k.zsh-theme" "$HOME/.zshrc"; then
    sed -i '/source ~\/powerlevel10k\/powerlevel10k.zsh-theme/d' "$HOME/.zshrc"
    echo "✅ Строка подключения темы удалена из ~/.zshrc."
else
    echo "ℹ️ Строка темы Powerlevel10k не найдена в ~/.zshrc."
fi

echo ""
echo "🧨 Удаление Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "⚙️ Запуск скрипта удаления Oh My Zsh..."
    sh "$HOME/.oh-my-zsh/tools/uninstall.sh" -y
else
    echo "ℹ️ Oh My Zsh не установлен."
fi

rm -rf "$HOME/.zshrc.omz-uninstalled-*"

echo ""
echo "✅ Удаление завершено. Перезапустите терминал или выполните команду: source ~/.zshrc"
echo "✨ Все выбранные компоненты были успешно удалены!"
