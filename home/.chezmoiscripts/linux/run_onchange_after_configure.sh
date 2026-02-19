#! /usr/bin/env bash

set -eufo pipefail

# Dock settings
gsettings set org.gnome.shell favorite-apps "['chromium-browser.desktop', 'org.mozilla.firefox.desktop', 'kitty.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'code.desktop']"  

# Nautilus settings
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences date-time-format 'detailed'
gsettings set org.gnome.nautilus.preferences default-sort-order 'mtime'
gsettings set org.gnome.nautilus.preferences show-hidden-files true

# Clock settings
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-seconds true
