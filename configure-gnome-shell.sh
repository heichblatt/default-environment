#!/bin/sh

set -e

echo -n "Configuring GNOME Shell.. "

gsettings set org.gnome.shell.extensions.dock position left
gsettings set org.gnome.shell.clock show-date true
gsettings set org.gnome.shell.calendar show-weekdate true
gsettings set org.gnome.shell enabled-extensions "['alternative-status-menu@gnome-shell-extensions.gcampax.github.com', 'dock@gnome-shell-extensions.gcampax.github.com', 'systemMonitor@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'gedit.desktop', 'nautilus.desktop', 'gnome-terminal.desktop', 'icedove.desktop', 'libreoffice-writer.desktop', 'empathy.desktop', 'rhythmbox.desktop', 'shotwell.desktop']"
gsettings set org.gnome.rhythmbox.plugins active-plugins "['iradio', 'mpris', 'rb', 'mmkeys', 'mtpdevice', 'generic-player', 'artsearch', 'power-manager', 'dbus-media-server', 'audiocd']"
gsettings set org.gnome.rhythmbox.podcast download-location file:...home.$USER.Podcasts
gsettings set org.gnome.rhythmbox.player play-order linear
gsettings set org.gnome.rhythmbox.rhythmdb monitor-library true
gsettings set org.gnome.nautilus.preferences default-folder-viewer list-view
gsettings set org.gnome.nautilus.preferences enable-delete true
gsettings set org.gnome.settings-daemon.plugins.power sleep-display-ac "0"
gsettings set org.gnome.settings-daemon.plugins.power sleep-display-battery "0"
gsettings set org.gnome.settings-daemon.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.sound event-sounds false
gconftool-2 -s --type bool /apps/gnome-terminal/profiles/Default/default_show_menubar false

echo OK
