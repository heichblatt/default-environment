#!/bin/bash

# install TOR Browser Bundle for current user
# $1 installation directory, defaults to ~/bin

set -e

URLPREFIX=https://www.torproject.org/dist/torbrowser/3.5/
URLDOWNLOADPAGE=/

if [ "$#" == "0" ]; then
	INSTALLDIR="$HOME"/bin
    echo "No arguments provided."
else
	INSTALLDIR="$1"
fi

echo "Using $INSTALLDIR as installation directory."
mkdir -p "$INSTALLDIR"

# get the current tarball's URL
URL="$URLPREFIX"/$(wget -q -O- "$URLPREFIX"/"$URLDOWNLOADPAGE" | grep href | grep tor-browser-linux64 | grep _en-US.tar.xz | grep -v .asc | cut -d\" -f 6)

# download and untar the tarball
wget -O- "$URL" | tar -xvJ -C "$INSTALLDIR"

# write .desktop file
cat > "$HOME"/.local/share/applications/tor-browser.desktop <<END
[Desktop Entry]
Version=1.0
Type=Application
Name=Tor-Browser
Exec=${INSTALLDIR}/tor-browser_en-US/start-tor-browser
Icon=${INSTALLDIR}/tor-browser_en-US/App/Firefox/icons/mozicon128.png
Categories=Network;
Comment=Browse the Web anonymously.
END

trap "" SIGHUP SIGINT SIGTERM