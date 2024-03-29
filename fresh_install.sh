#!/bin/bash

mkdir ~/bin/

# manually mount Old-Home folder
mkdir ~/Old-Home
sudo mount $(sudo blkid | grep Old-Home | sed -r -n 's/(.*)\:.*/\1/p') ~/Old-Home
WORKSPACE_FOLDER="Old-Home/zealot"
ln -sf $(realpath $WORKSPACE_FOLDER/workspace_mine) .
ln -sf $(realpath $WORKSPACE_FOLDER/workspace_misc) .
ln -sf $(realpath $WORKSPACE_FOLDER/workspace_eh) .

CONFIG_FOLDER="Old-Home/zealot"
cp -rp $CONFIG_FOLDER/.ssh .
cp -rp $CONFIG_FOLDER/.aws .
cp -rp $CONFIG_FOLDER/.kube .

# migrate google-chrome data
cp -rp /home/zealot/Old-Root/home/zealot/.config/google-chrome ~/.config/
## remove ~/.config/google-chrome/Default/Login Data.. Login Data-journal
rm ~/.config/google-chrome/default/Login\ Data*

# install dropbox
google-chrome https://www.dropbox.com/install?os=lnx

# reconfigure locale
# remember to use `en_US.UTF-8 UTF-8`
sudo dpkg-reconfigure locales

# reconfigure postgresql
sudo cp ~/dotfiles/applications-config/etc/postgresql/10/main/pg_hba.conf \
     /etc/postgresql/10/main/pg_hba.conf
sudo systemctl restart postgresql
psql -U postgres -c "CREATE USER $USER;"
psql -U postgres -c "CREATE DATABASE $USER;"
psql -U postgres -c "ALTER USER $USER with superuser createrole createdb replication bypassrls"

# install nerd font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git &&
  nerd-fonts/install.sh &&
  mv nerd-fonts ~/workspace_misc/

# install teensy_loader_cli
git -C ~/workspace_misc/ clone https://github.com/PaulStoffregen/teensy_loader_cli &&
    cd ~/workspace_misc/teensy_loader_cli &&
    make && sudo cp teensy_loader_cli /usr/local/bin/

# install find-cursor
git clone https://github.com/arp242/find-cursor.git && cd find-cursor &&
    make && sudo mkdir -p /usr/local/share/man/man1/ && sudo make install &&
    cd .. && mv find-cursor ~/workspace_misc/

# install discord
wget --content-disposition https://discordapp.com/api/download\?platform\=linux\&format\=deb
sudo gdebi -n discord*.deb

# install slack
google-chrome https://slack.com/intl/en-vn/downloads/instructions/ubuntu
sudo gdebi -n slack-desktop*amd64.deb

# install viber
wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
sudo gdebi -n viber.deb

# install telegram
google-chrome https://telegram.org/dl/desktop/linux
tar -xvf tsetup.*.tar.xz
mv Telegram ~/bin/

# install skype
google-chrome https://www.skype.com/en/get-skype/
sudo gdebi -n skypeforlinux-64.deb

# install gnome-extensions
mkdir -p ~/.local/share/gnome-shell/extensions

## unite
## https://extensions.gnome.org/extension/1287/unite/
## gtile
## https://extensions.gnome.org/extension/28/gtile/

# some misc command

# nvidia fanspeed setting
## edit /usr/share/X11/xorg.conf.d/10-nvidia.conf
## value:
# Section "OutputClass"
#     Identifier "nvidia"
#     MatchDriver "nvidia-drm"
#     Driver "nvidia"
#     Option "AllowEmptyInitialConfiguration"
#     Option "Coolbits" "28"
#     ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
# EndSection
## enable control nvidia-card-fan-speed
## sudo nvidia-xconfig -a --cool-bits=28

# install linux-brew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# install grc
git clone git@github.com:zealotnt/grc.git && mv grc ~/workspace_misc/ && cd ~/workspace_misc/grc && sudo ./install.sh && cd


# install figlet-fonts
git -C ~/workspace_misc/ clone https://github.com/xero/figlet-fonts &&
    sudo mkdir -p /usr/share/figlet/fonts/ &&
    sudo cp ~/workspace_misc/figlet-fonts/* /usr/share/figlet/fonts/

# vietnamese typing
# basically, dconf already setup the neccessary configuration for vietnamese typing
# but things still need to be configured correctly
# follow settings -> Region & Language -> Language -> {ubuntu will prompt to install the missing pieces}

# devops specific

# install libreoffice
google-chrome https://www.libreoffice.org/donate/dl/deb-x86_64/6.3.4/en-US/LibreOffice_6.3.4_Linux_x86-64_deb.tar.gz
x LibreOffice_6.3.4_Linux_x86-64_deb.tar.gz
cd LibreOffice_6.3.4_Linux_x86-64_deb/DEBS
sudo dpkg -i *.deb

# TODO: install golang
google-chrome https://golang.org/dl/
sudo tar -C /usr/local -xzf go*-amd64.tar.gz

## install govendor
go get -u github.com/kardianos/govendor

# install noti
curl -s https://api.github.com/repos/variadico/noti/releases/latest \
| awk '/browser_download_url/ { print $2 }' \
| grep 'linux-amd64' | sed 's/"//g' \
| wget -i -

# install arandr
git -C ~/workspace_misc/ clone https://gitlab.com/arandr/arandr
cd ~/workspace_misc/arandr && sudo ./setup.py install

# clone, compile and install ncdu
git -C ~/workspace_misc/ clone git://g.blicky.net/ncdu.git/ &&
    cd ~/workspace_misc/ncdu &&
    autoreconf -i && ./configure &&
    make && sudo make install

# install sound-use-both-headphone-and-lineout
~/dotfiles/pulseaudio/install.sh
# install autostart
~/dotfiles/autostart/install.sh

# Emacs
# install emacs config
ln -sf $(realpath workspace_mine/w_emacs_dotfiles/init.el) .emacs.d
## install all-the-icons
emacsclient --eval "(all-the-icons-install-fonts t)"
## for go-imenu
go get -u github.com/lukehoban/go-outline

#############################################################
# big fat heavy packages
sudo apt install -y kicad

# TODO: remaining items needs to be done list here
# install https://github.com/Hummer12007/brightnessctl
#   sudo chmod u+s /usr/bin/brightnessctl
# write a script to notify/update to i3blocks about screen brightness

# install mpv
#sudo add-apt-repository ppa:mc3man/mpv-tests
#sudo apt install mpv
# add mpv config files
mkdir -p ~/.config/mpv
ln -sf $(realpath mpv.conf) ~/.config/mpv/mpv.conf
ln -sf $(realpath mpv-input.conf) ~/.config/mpv/input.conf
# trying to build from source, not work yet
# sudo apt install -y libass-dev libavutil-dev libavcodec-dev libavformat-dev \
#     libavfilter-dev libswresample-dev liblcms2-dev libarchive-dev # not use


cat <<EOT >> /etc/fstab
UUID=2f74c552-3ebb-4e63-91e2-94a53c4ddc20 /home/zealot/Media-Sharing          ext4    errors=remount-ro 0       1
#UUID=cdd634b1-1ba8-4096-a405-638759f718ce /home/zealot/Old-Root               ext4    errors=remount-ro 0       1
#UUID=beecf8ae-61c0-44be-9a03-4a684d7e41c5 /home/zealot/Old-Home2              ext4    errors=remount-ro 0       1
UUID=5bdab27b-6c4b-44c8-a96a-ef8d33c1424c /home/zealot/Old-Home               ext4    errors=remount-ro 0       1
EOT
