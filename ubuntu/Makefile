SHELL = /bin/bash
INSTALL = apt-get install -y
UPDATE = apt-get update
UPGRADE = apt-get dist-upgrade -y
REMOVE = apt-get autoremove --purge -y
DISTFILESDIR = ../distfiles
USERNAME = heichblatt
DOWNLOADDISTFILE=wget -c --directory-prefix=$(DISTFILESDIR)
ADDPPA = apt-add-repository -y 
SRCDIR = $(HOME)/src

all: upgrade distfilesdir system network development productivity configure-git multimedia virtualization latex clean

system:
	$(INSTALL) tmux htop iftop iotop git-core etckeeper vim build-essential ubuntu-restricted-extras sudo ncdu pass synaptic trash-cli rsnapshot mc
	-$(REMOVE) apport

multimedia: system
	$(INSTALL) vlc mplayer

network: distfilesdir
	$(INSTALL) network-manager-openvpn-gnome network-manager-openvpn nmap wireshark torsocks tor sshfs transgui openssh-server
	$(DOWNLOADDISTFILE) https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	-dpkg -i $(DISTFILESDIR)/google-chrome-stable_current_amd64.deb
	$(INSTALL) -f
	$(ADDPPA) ppa:ajf/trg
	$(UPDATE)
	$(INSTALL) transmission-remote-gtk
	$(ADDPPA) ppa:upubuntu-com/tor64
	$(UPDATE)
	$(INSTALL) tor-browser
	su $(USERNAME) -c mkdir -p /home/$(USERNAME)/.tor-browser
	chown -R $(USERNAME) /home/$(USERNAME)/.tor-browser
	$(ADDPPA) ppa:smathot/cogscinl
	$(UPDATE)
	$(INSTALL) zotero-standalone

distfilesdir:
	mkdir -p $(DISTFILESDIR)

latex:
	$(INSTALL) texlive-fonts-recommended texlive-latex-base texlive-lang-german gedit-latex-plugin texlive-latex-extra texlive-latex-recommended gummi

clean:
	rm -r $(DISTFILESDIR)

virtualization:
	echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" > /etc/apt/sources.list.d/virtualbox.list
	wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
	$(UPDATE)
	$(INSTALL) virtualbox-4.1 libxslt-dev libxml2-dev zlib1g-dev
	usermod -aG vboxusers $(USERNAME)
	gem install fog --version 1.8 --no-ri --no-rdoc && gem install veewee --no-ri --no-rdoc # until veewee issue 611 is fixed

development:
	$(INSTALL) gitg meld build-essential

productivity:
	$(INSTALL) calibre encfs rubygems ruby-redcloth vagrant keepassx keepass2 pandoc wine winetricks gnupg2 libnotify-bin deja-dup graphviz
	gem install jekyll --no-ri --no-rdoc

configure-git: system
	git config --global user.name "Hannes Eichblatt"
	git config --global user.email mail@hanneseichblatt.de

configure-vim: srcdir-exists system
	cd $(SRCDIR) 	\
	&& git clone git@github.com:heichblatt/dotfiles-vim.git	\
	&& cd dotfiles-vim \
	&& ./install.sh

srcdir-exists:
	test -d $(SRCDIR) || mkdir -pm $(SRCDIR)

upgrade:
	$(UPDATE)
	$(UPGRADE)
