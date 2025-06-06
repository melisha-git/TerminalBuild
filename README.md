# 🛠️ TerminalBuild

TerminalBuild — это коллекция скриптов для быстрой настройки окружения терминала и редактора Visual Studio Code. Скрипты автоматически устанавливают/удаляют полезные утилиты, настраивают удобные бинды и делают работу в терминале более комфортной.

---

## Предварительные шаги

Перед установкой убедитесь, что выполнены следующие действия:

1. Установите Zsh
```
sudo apt install zsh -y
```

2. Установите мультиплексер [Ghostty](https://github.com/mitchellh/ghostty)
```
sudo snap install ghostty --classic
```
3. (Опционально) Установите Visual Studio Code
```
sudo apt install code
```
4. Запустите Ghostty
```
ghostty
```
---

## ⚙️ Установка и запуск

1. Склонируйте репозиторий
```
git clone https://github.com/melisha-git/TerminalBuild.git
```
2. Установите
```
cd TerminalBuild
chmod +x install.sh
./install.sh
./vscode-tools-install.sh # (опционально)
exec zsh #or source .zshrc
```
---

## Удаление

Для удаления установленных компонентов:
```
cd TerminalBuild
chmod +x uninstall.sh
./uninstall.sh
./vscode-tools-uninstall.sh # (опционально)
```
---

## Горячие клавиши (бинды) для Ghostty

| Клавиша               | Действие                    |
| --------------------- | --------------------------- |
| Alt + W             | Новый терминал              |
| Alt + A             | Сплит-окно справа           |
| Alt + S             | Сплит-окно снизу            |
| Alt + D             | Сплит-окно слева            |
| Alt + W             | Сплит-окно сверху           |
| Alt + Z             | Закрыть текущее окно        |
| Alt + R             | Применить изменения конфига |
| Alt + ← / → / ↑ / ↓ | Перемещение между окнами    |

> *Убедитесь, что используете Ghostty внутри совместимого терминального эмулятора.*

---

## Структура проекта
```
TerminalBuild/
├── install.sh                # Установка основных утилит
├── vscode-tools-install.sh  # Установка расширений и настроек для VSCode
├── vscode-tools-uninstall.sh# Удаление VSCode-настроек
└── README.md                 # Документация проекта
```
---

## Планируемые улучшения (TODO)

* [ ] Добавить поддержку других терминальных эмуляторов
* [ ] GUI-меню выбора устанавливаемых пакетов
* [ ] Обновление через git pull и перезапуск скриптов

---

## Автор

[@melisha-git](https://github.com/melisha-git)
[@/bin/notes](https://t.me/bin_notes)

Pull Requests и Issues приветствуются!

---
