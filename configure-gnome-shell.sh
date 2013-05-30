#!/bin/sh

set -e

echo -n "Configuring GNOME Shell.. "

dconf write /org/gnome/shell/extensions/dock/position "'left'"
dconf write /org/gnome/shell/clock/show-date "'true'"
dconf write /org/gnome/shell/calendar/show-weekdate "'true'"
dconf write /org/gnome/shell/enabled-extensions "['alternative-status-menu@gnome-shell-extensions.gcampax.github.com', 'dock@gnome-shell-extensions.gcampax.github.com', 'systemMonitor@gnome-shell-extensions.gcampax.github.com']"
dconf write /org/gnome/shell/favorite-apps "[google-chrome.desktop', 'gedit.desktop', 'nautilus.desktop', 'gnome-terminal.desktop', 'icedove.desktop', 'libreoffice-writer.desktop', 'empathy.desktop', 'rhythmbox.desktop', 'shotwell.desktop']"
dconf write /org/gnome/rhythmbox/plugins/active-plugins "['iradio', 'mpris', 'rb', 'mmkeys', 'mtpdevice', 'generic-player', 'artsearch', 'power-manager', 'dbus-media-server', 'audiocd']"
dconf write /org/gnome/rhythmbox/podcast/download-location "'file:///home/$USER/Podcasts'"
dconf write /org/gnome/rhythmbox/player/play-order "'linear'"
dconf write /org/gnome/rhythmbox/rhythmdb/monitor-library "'true'"
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'list-view'"
dconf write /org/gnome/nautilus/preferences/enable-delete "'true'"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-display-ac "0"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-display-battery "0"
dconf write /org/gnome/settings-daemon/peripherals/touchpad/disable-while-typing "'true'"
dconf write /org/gnome/settings-daemon/peripherals/touchpad/tap-to-click "'true'"
dconf write /org/gnome/desktop/sound/event-sounds "'false'"
gconftool-2 --set /apps/gnome-terminal/profiles/Default/default_show_menubar --type boolean false

echo OK
