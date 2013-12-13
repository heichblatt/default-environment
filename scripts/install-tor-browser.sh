#!/bin/bash

# install TOR Browser Bundle for current user
# $1 installation directory, defaults to ~/bin

URLPREFIX=https://www.torproject.org/download
URLDOWNLOADPAGE=download-easy.html.en

if [ "$#" == "0" ]; then
	INSTALLDIR="$HOME"/bin
    echo "No arguments provided, using default installation directory."
else
	INSTALLDIR="$1"
fi

echo "Using $INSTALLDIR as installation directory."
mkdir -p "$INSTALLDIR"

# get the current tarball's URL
URL="$URLPREFIX"/$(wget -q -O- "$URLPREFIX"/"$URLDOWNLOADPAGE" | grep "button lin-tbb6" | grep href | grep tar.gz | cut -d\" -f 4)

# download and untar the tarball
wget -O- "$URL" | tar -xvz -C "$INSTALLDIR"

trap "" SIGHUP SIGINT SIGTERM