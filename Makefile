SHELL=/bin/bash
INSTALL=sudo apt-get install -y
UPDATE=sudo apt-get update
UPGRADE=sudo apt-get dist-upgrade -y
USERNAME=heichblatt
BASEDIR=.
DISTFILESDIR=$(BASEDIR)/distfiles
SCRIPTSDIR=$(BASEDIR)/scripts
DOWNLOADDISTFILE=wget --directory-prefix=$(DISTFILESDIR)
INSTALLGEM=sudo gem install
GEMOPTS=--no-rdoc --no-ri

all: sudoers-nopasswd system productivity iceweasel-release development multimedia network virtualization latex upgrade autoremove clean

upgrade:
	$(UPDATE)
	$(UPGRADE)

system: pass git
	$(INSTALL) tmux htop iftop iotop etckeeper vim sudo ncdu pass synaptic libxslt-dev libxml2-dev zlib1g-dev mc renameutils rubygems python-pip deborphan checkinstall etherwake unrar apt-file
	sudo apt-file update
	sudo usermod -aG sudo $(USERNAME)

multimedia:
	$(INSTALL) vlc gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly lame pavucontrol mplayer

network: transmission-remote-gtk
	$(INSTALL) network-manager-openvpn-gnome nmap wireshark torsocks tor sshfs transgui openssh-server remmina trickle

virtualization:
	sudo cp $(BASEDIR)/sources.list.d/virtualbox.list /etc/apt/sources.list.d/virtualbox.list
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
	$(INSTALL) gnome chromium-browser calibre encfs ruby-redcloth vagrant keepassx keepass2 pandoc wine winetricks gnupg2 libnotify-bin deja-dup simple-scan rhythmbox seahorse terminator gnome-tweak-tool ttf-mscorefonts-installer vim-gtk flashplugin-nonfree cups-pdf graphviz imagemagick icedove icedove-l10n-de
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
	sudo cp $(BASEDIR)/sources.list.d/iceweasel-release.list /etc/apt/sources.list.d/
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
	sudo cp ./sudoers.d/nopasswd /etc/sudoers.d/$(USERNAME)
	sudo sed -i 's/USERNAME/$(USERNAME)/g' /etc/sudoers.d/$(USERNAME)

git:
	$(INSTALL) git-core
	
offlineimap-from-source: git distfiles-dir
	cd $(DISTFILESDIR) && \
	git clone git://github.com/spaetz/offlineimap.git && \
	cd offlineimap/ && \
	make clean && make && \
	sudo checkinstall -y python setup.py install
