#!/bin/bash

# install TOR Browser Bundle for current user
# $1 installation directory, defaults to ~/bin

set -e

URLPREFIX=https://www.torproject.org/download
URLDOWNLOADPAGE=download-easy.html.en

if [ "$#" == "0" ]; then
	INSTALLDIR="$HOME"/bin
    echo "No arguments provided."
else
	INSTALLDIR="$1"
fi

echo "Using $INSTALLDIR as installation directory."
mkdir -p "$INSTALLDIR"

# get the current tarball's URL
URL="$URLPREFIX"/$(wget -q -O- "$URLPREFIX"/"$URLDOWNLOADPAGE" | grep "button lin-tbb6" | grep href | grep tar.gz | cut -d\" -f 4)

# download and untar the tarball
wget -O- "$URL" | tar -xvz -C "$INSTALLDIR"

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