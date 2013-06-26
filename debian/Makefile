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
	$(INSTALL) tmux htop iftop iotop etckeeper git-core vim sudo ncdu pass synaptic libxslt-dev libxml2-dev zlib1g-dev mc
	usermod -aG sudo $(USERNAME)

multimedia:
	$(INSTALL) vlc gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly lame pavucontrol mplayer

network: google-chrome
	$(INSTALL) network-manager-openvpn-gnome nmap wireshark torsocks tor sshfs transgui openssh-server remmina
	
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

google-chrome: distfiles-dir
	$(DOWNLOADDISTFILE) https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	-dpkg -i $(DISTFILESDIR)/google-chrome-stable_current_amd64.deb
	$(INSTALL) -f
	cp ../google-chrome/google-chrome.desktop /usr/share/applications

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
