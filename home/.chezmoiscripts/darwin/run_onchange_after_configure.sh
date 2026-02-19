#! /usr/bin/env bash

set -eufo pipefail

# UI settings
defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Language/locale settings
defaults write NSGlobalDomain AppleLanguages -array "en-US"
defaults write NSGlobalDomain AppleLocale "en_US"

# Dock settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

# Finder settings
defaults write com.apple.finder AppleShowAllFiles -bool true

# Clock settings
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# Login items
osascript -e 'tell application "System Events" to make new login item at end with properties {path:"/Applications/Rectangle.app", hidden:false}'

# Auto sleep
sudo systemsetup -setcomputersleep never
