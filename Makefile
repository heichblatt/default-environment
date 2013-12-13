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

all: sudoers-nopasswd system productivity user-dirs iceweasel-release development multimedia network latex upgrade autoremove clean pidgin-jabber-ccc-cert
extras: skype sublime-text2 latex virtualization

upgrade:
	$(UPDATE)
	$(UPGRADE)

system: pass git
	$(INSTALL) tmux htop iftop iotop etckeeper vim sudo ncdu pass synaptic libxslt-dev libxml2-dev zlib1g-dev mc renameutils rubygems python-pip deborphan checkinstall etherwake unrar apt-file command-not-found
	sudo update-command-not-found
	sudo apt-file update
	sudo usermod -aG sudo $(USERNAME)

multimedia:
	$(INSTALL) vlc gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly lame pavucontrol mplayer

network: transmission-remote-gtk
	$(INSTALL) network-manager-openvpn-gnome nmap wireshark torsocks tor sshfs transgui openssh-server remmina trickle

virtualization:
	sudo cp $(BASEDIR)/etc/sources.list.d/virtualbox.list /etc/apt/sources.list.d/virtualbox.list
	wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
	$(UPDATE)
	$(INSTALL) virtualbox-4.1
	sudo usermod -aG vboxusers $(USERNAME)
	( gem list | grep "fog (1.8.0)" || $(INSTALLGEM) fog --version 1.8 $(GEMOPTS) ) && \
		( which veewee | grep veewee || $(INSTALLGEM) veewee $(GEMOPTS) ) # fixed fog version until veewee issue 611 is fixed

development: git
	$(INSTALL) gitg meld build-essential

productivity: iceweasel-release
	sudo tasksel install desktop
	$(INSTALL) gnome chromium-browser calibre encfs ruby-redcloth vagrant keepassx keepass2 pandoc wine winetricks gnupg2 libnotify-bin deja-dup simple-scan rhythmbox seahorse terminator gnome-tweak-tool ttf-mscorefonts-installer vim-gtk flashplugin-nonfree cups-pdf graphviz imagemagick icedove icedove-l10n-de irssi irssi-scripts
	which jekyll || $(INSTALLGEM) jekyll $(GEMOPTS)
	-$(SCRIPTSDIR)/configure-gnome-shell.sh

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
	sudo cp $(BASEDIR)/etc/sources.list.d/iceweasel-release.list /etc/apt/sources.list.d/
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
	sudo dpkg -i $(DISTFILESDIR)/skype.deb
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
