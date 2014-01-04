SHELL=/bin/bash
INSTALL=sudo apt-get install -y
UPDATE=sudo apt-get update
UPGRADE=sudo apt-get dist-upgrade -y
USERNAME=$(shell whoami)
BASEDIR=.
DISTFILESDIR=$(BASEDIR)/distfiles
SCRIPTSDIR=$(BASEDIR)/scripts
DOWNLOADDISTFILE=wget --directory-prefix=$(DISTFILESDIR)
INSTALLGEM=sudo gem install
GEMOPTS=--no-rdoc --no-ri
USERBINDIR=$(HOME)/bin

all: sudoers-nopasswd system productivity user-dirs iceweasel-release development multimedia vlsub network upgrade autoremove clean
extras: skype sublime-text2 latex virtualisation multisystem zfs

upgrade:
	$(UPDATE)
	$(UPGRADE)

system: pass git blacklist-pcspkr
	$(INSTALL) tmux htop iftop iotop etckeeper vim sudo ncdu pass synaptic libxslt-dev libxml2-dev zlib1g-dev mc renameutils rubygems python-pip deborphan checkinstall etherwake unrar apt-file command-not-found task-german firmware-iwlwifi
	sudo update-command-not-found
	sudo apt-file update
	-sudo modprobe -r iwlwifi && sudo modprobe iwlwifi
	sudo service network-manager restart
	sudo usermod -aG sudo $(USERNAME)

multimedia:
	$(INSTALL) vlc gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly lame pavucontrol mplayer

network: transmission-remote-gtk
	$(INSTALL) network-manager-openvpn-gnome nmap wireshark torsocks tor sshfs transgui openssh-server remmina trickle

virtualisation: virtualbox #veewee

virtualbox:
	sudo cp $(BASEDIR)/etc/apt/sources.list.d/virtualbox.list /etc/apt/sources.list.d/virtualbox.list
	wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
	$(UPDATE)
	$(INSTALL) virtualbox-4.1 linux-headers-amd64
	sudo service vboxdrv setup
	sudo usermod -aG vboxusers $(USERNAME)

veewee:
	( gem list | grep "fog (1.8.0)" || $(INSTALLGEM) fog --version 1.8 $(GEMOPTS) ) && \
		( which veewee | grep veewee || $(INSTALLGEM) veewee $(GEMOPTS) ) # fixed fog version until veewee issue 611 is fixed

remove-all-rubygems:
	sudo 'gem list | cut -d" " -f1 | xargs gem uninstall -aIx'

development: git
	$(INSTALL) gitg meld build-essential

productivity: iceweasel-release pidgin-jabber-ccc-cert workaround-pidgin-libnotify
	$(INSTALL) chromium-browser calibre encfs ruby-redcloth vagrant keepassx keepass2 pandoc wine winetricks gnupg2 libnotify-bin deja-dup simple-scan rhythmbox seahorse terminator ttf-mscorefonts-installer vim-gtk flashplugin-nonfree cups-pdf graphviz imagemagick icedove icedove-l10n-de irssi irssi-scripts surfraw duply
	which jekyll || $(INSTALLGEM) jekyll $(GEMOPTS)

latex:
	$(INSTALL) texlive-fonts-recommended texlive-latex-base texlive-lang-german gedit-latex-plugin texlive-latex-extra texlive-latex-recommended gummi latexmk

pass:
	which pass || ( $(DOWNLOADDISTFILE) http://ftp.de.debian.org/debian/pool/main/p/password-store/pass_1.4.2-1_all.deb && \
	sudo dpkg -i $(DISTFILESDIR)/pass_*deb ; \
	$(INSTALL) -f )

user-dirs:
	-mkdir $(HOME)/{Dokumente,Downloads,Vorlagen,Öffentlich,Desktop,Musik,Bilder,Videos}
	-mkdir -p $(HOME)/.config
	cp $(BASEDIR)/user-dirs/* $(HOME)/.config
	xdg-user-dirs-update

distfiles-dir:
	mkdir -p $(DISTFILESDIR)

clean:
	sudo rm -rf $(DISTFILESDIR)

iceweasel-release:
	sudo cp $(BASEDIR)/etc/apt/sources.list.d/iceweasel-release.list /etc/apt/sources.list.d/
	$(UPDATE)
	$(INSTALL) --allow-unauthenticated pkg-mozilla-archive-keyring
	$(UPDATE)
	$(INSTALL) -t wheezy-backports iceweasel

transmission-remote-gtk: distfiles-dir system
	$(INSTALL) intltool pkg-config libjson-glib-dev libgtk-3-dev libcurl4-gnutls-dev
	$(DOWNLOADDISTFILE) https://transmission-remote-gtk.googlecode.com/files/transmission-remote-gtk-1.1.1.tar.gz
	cd $(DISTFILESDIR) && \
	tar xf transmission-remote-gtk-1.1.1.tar.gz && \
	cd transmission-remote-gtk-1.1.1/ && \
	./configure --prefix=/usr/ && make && sudo checkinstall -D -y --install

autoremove:
	sudo apt-get autoremove -y

sudoers-nopasswd:
	sudo cp ./etc/sudoers.d/nopasswd /etc/sudoers.d/$(USERNAME)
	sudo sed -i 's/USERNAME/$(USERNAME)/g' /etc/sudoers.d/$(USERNAME)

git:
	$(INSTALL) git-core
	
offlineimap-from-source: git distfiles-dir
	cd $(DISTFILESDIR) && \
	git clone git://github.com/spaetz/offlineimap.git && \
	cd offlineimap/ && \
	make clean && make && \
	sudo checkinstall -y python setup.py install

pidgin-jabber-ccc-cert:
	mkdir -pv $(HOME)/.purple/certificates/x509/tls_peers/
	cp -v ./certs/jabber.ccc.de $(HOME)/.purple/certificates/x509/tls_peers/

multiarch:
	sudo dpkg --add-architecture i386
	sudo apt-get update

skype: distfiles-dir multiarch
	wget -O $(DISTFILESDIR)/skype.deb http://www.skype.com/go/getskype-linux-deb
	-sudo dpkg -i $(DISTFILESDIR)/skype.deb
	$(INSTALL) -f

mpd:
	$(INSTALL) mpd sonata ncmpcpp
	sudo cp -v ./etc/mpd.conf /etc/
	mkdir -pv $(HOME)/.mpd
	mkdir -pv $(HOME)/.mpd/playlists
	sudo sed -i 's/HOME/\/home\/$(USERNAME)/g' /etc/mpd.conf
	sudo sed -i 's/USERNAME/$(USERNAME)/g' /etc/mpd.conf
	sudo service mpd restart

sublime-text2: distfiles-dir
	wget -O $(DISTFILESDIR)/sublime-text2.tar.bz2 "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2"	
	cd $(DISTFILESDIR) && \
		tar xf sublime-text2.tar.bz2 && \
		sudo mv -f ./Sublime\ Text\ 2 /opt/
	sudo ln -fs /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime && \
	sudo cp -f $(BASEDIR)/usr/share/applications/sublime.desktop /usr/share/applications/sublime.desktop
	mkdir -pv $(HOME)/.config/sublime-text-2/Packages/Installed\ Packages
	wget -O $(HOME)/.config/sublime-text-2/Packages/Installed\ Packages/Package\ Control.sublime-package https://sublime.wbond.net/Package%20Control.sublime-package

owncloud-client: distfiles-dir
	sudo cp -f $(BASEDIR)/etc/apt/sources.list.d/owncloud-client.list /etc/apt/sources.list.d/owncloud-client.list
	wget -q -O- http://download.opensuse.org/repositories/isv:ownCloud:desktop/Debian_7.0/Release.key | sudo apt-key add -
	$(UPDATE)
	$(INSTALL) owncloud-client

tor-browser:
	$(SCRIPTSDIR)/install-tor-browser.sh $(USERBINDIR)

gnome:
	sudo tasksel install desktop
	$(INSTALL) task-german-desktop gnome gnome-tweak-tool
	-$(SCRIPTSDIR)/configure-gnome-shell.sh

kde:
	$(INSTALL) task-kde-desktop task-german-kde-desktop kde-config-gtk-style gtk2-engines-oxygen gtk3-engines-oxygen krdc amarok kshutdown yakuake

xfce4:
	$(INSTALL) task-xfce-desktop xfce4 xfce4-goodies

multisystem:
	sudo cp -f $(BASEDIR)/etc/apt/sources.list.d/multisystem.list /etc/apt/sources.list.d/multisystem.list
	wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | sudo apt-key add -
	$(UPDATE)
	$(INSTALL) multisystem
	sudo usermod -aG adm $(USERNAME)

zfs: distfiles-dir
	wget -O $(DISTFILESDIR)/zfsonlinux.deb "http://archive.zfsonlinux.org/debian/pool/main/z/zfsonlinux/zfsonlinux_2%7Ewheezy_all.deb"
	sudo dpkg -i $(DISTFILESDIR)/zfsonlinux.deb
	$(UPDATE)
	$(INSTALL) debian-zfs

backports:
	sudo cp -f $(BASEDIR)/etc/apt/sources.list.d/backports.list /etc/apt/sources.list.d/backports.list
	$(UPDATE)

backported-kernel: backports
	$(INSTALL) -t wheezy-backports linux-image-amd64 linux-headers-amd64

# pidgin-libnotify is missing from Debian wheezy
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=706979
workaround-pidgin-libnotify: distfiles-dir
	$(DOWNLOADDISTFILE) http://ftp.de.debian.org/debian/pool/main/p/pidgin-libnotify/pidgin-libnotify_0.14-9_amd64.deb
	-sudo dpkg -i $(DISTFILESDIR)/pidgin-libnotify*deb
	$(INSTALL) -f

vlsub: distfiles-dir
	wget -cO $(DISTFILESDIR)/vlsub.deb http://addons.videolan.org/CONTENT/content-files/148752-vlc-plugin-vlsub_0.9.10_all.deb
	-sudo dpkg -i $(DISTFILESDIR)/vlsub.deb
	$(INSTALL) -f

blacklist-pcspkr:
	sudo cp -f $(BASEDIR)/etc/modprobe.d/blacklist-pcspkr.conf /etc/modprobe.d/blacklist-pcspkr.conf
	-sudo rmmod pcspkr
