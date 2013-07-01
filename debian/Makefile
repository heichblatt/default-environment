SHELL=/bin/bash
INSTALL=apt-get install -y
UPDATE=apt-get update
UPGRADE=apt-get dist-upgrade -y
USERNAME=heichblatt
DISTFILESDIR=../distfiles
DOWNLOADDISTFILE=wget --directory-prefix=$(DISTFILESDIR)
INSTALLGEM=gem install
GEMOPTS=--no-rdoc --no-ri

all: system productivity development multimedia network virtualization latex upgrade clean

upgrade:
	$(UPDATE)
	$(UPGRADE)

system: pass
	$(INSTALL) tmux htop iftop iotop etckeeper git-core vim sudo ncdu pass synaptic libxslt-dev libxml2-dev zlib1g-dev mc renameutils
	usermod -aG sudo $(USERNAME)

multimedia:
	$(INSTALL) vlc gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly lame pavucontrol mplayer

network:
	$(INSTALL) network-manager-openvpn-gnome nmap wireshark torsocks tor sshfs transgui openssh-server remmina
	sudo update-alternatives --set x-www-browser $(which chromium-browser)

virtualization:
	echo "deb http://download.virtualbox.org/virtualbox/debian wheezy contrib" > /etc/apt/sources.list.d/virtualbox.list
	wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
	$(UPDATE)
	$(INSTALL) virtualbox-4.1
	usermod -aG vboxusers $(USERNAME)
	$(INSTALLGEM) fog --version 1.8 $(GEMOPTS) && $(INSTALLGEM) veewee $(GEMOPTS) # fixed version until veewee issue 611 is fixed

development:
	$(INSTALL) gitg meld build-essential

productivity:
	$(INSTALL) gnome calibre encfs rubygems ruby-redcloth vagrant keepassx keepass2 pandoc wine winetricks xul-ext-zotero icedove enigmail xul-ext-downthemall xul-ext-adblock-plus xul-ext-firebug xul-ext-flashblock xul-ext-gcontactsync gnupg2 libnotify-bin deja-dup terminator gnome-tweak-tool ttf-mscorefonts-installer vim-gtk
	$(INSTALLGEM) jekyll $(GEMOPTS)
	-su $(USERNAME) ../configure-gnome-shell.sh

latex:
	$(INSTALL) texlive-fonts-recommended texlive-latex-base texlive-lang-german gedit-latex-plugin texlive-latex-extra texlive-latex-recommended gummi

pass:
	$(DOWNLOADDISTFILE) http://ftp.de.debian.org/debian/pool/main/p/password-store/pass_1.4.2-1_all.deb
	-dpkg -i $(DISTFILESDIR)/pass_*deb
	$(INSTALL) -f

user-dirs:
	-mkdir $(HOME)/{Dokumente,Downloads,Vorlagen,Öffentlich,Desktop,Musik,Bilder,Videos}
	-mkdir -p $(HOME)/.config
	cp ../user-dirs/* $(HOME)/.config
	xdg-user-dirs-update

distfiles-dir:
	mkdir -p $(DISTFILESDIR)

clean:
	rm -rf $(DISTFILESDIR)

iceweasel-release:
	sudo echo "deb http://mozilla.debian.net/ wheezy-backports iceweasel-release" > /etc/apt/sources.list.d/iceweasel-release.list
	$(UPDATE)
	$(INSTALL) --allow-unauthenticated pkg-mozilla-archive-keyring
	$(UPDATE)
	$(INSTALL) -t wheezy-backports iceweasel

transmission-remote-gtk: distfiles-dir
	$(INSTALL) intltool pkg-config libjson-glib-dev libgtk-3-dev libcurl4-gnutls-dev
	$(DOWNLOADDISTFILE) https://transmission-remote-gtk.googlecode.com/files/transmission-remote-gtk-1.1.1.tar.gz
	cd $(DISTFILESDIR) && \
	tar xf transmission-remote-gtk-1.1.1.tar.gz && \
	cd transmission-remote-gtk-1.1.1/ && \
	./configure && make && sudo make install
