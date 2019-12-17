#!/bin/bash

mkdir ~/bin/

ln -sf $(realpath Old-Home/zealot/workspace_mine) .
ln -sf $(realpath Old-Home/zealot/workspace_misc) .
ln -sf $(realpath Old-Home/zealot/workspace_eo) .

cp -rp Old-Root/home/zealot/.ssh .
cp -rp Old-Root/home/zealot/.aws .
cp -rp Old-Root/home/zealot/.kube .

# migrate google-chrome data
cp -rp /home/zealot/Old-Root/home/zealot/.config/google-chrome ~/.config/
## remove ~/.config/google-chrome/Default/Login Data.. Login Data-journal
rm ~/.config/google-chrome/default/Login\ Data*


# install essential tools
sudo apt install -y git zsh curl zsh tmux google-chrome-stable emacs26 rofi ruby \
     gdebi apt-transport-https sublime-merge dconf-editor gnome-tweak-tool code \
     xdotool tree p7zip-full pavucontrol indicator-sound-switcher ibus-unikey \
     blueman neovim network-manager-openvpn figlet goldendict silversearcher-ag \
     copyq minicom neofetch nodejs npm nnn alacritty spotify-client ubuntu-make \
     libdbus-1-dev `# requires for mpris-control` \
     python-dev python-pip python3-dev python3-pip `# requies for neovim related` \
     libx11-dev apt-file libxdamage-dev libxrender-dev libxext-dev `# requires to compile find-cursor` \
     vlc gnupg-agent docker-ce docker-ce-cli containerd.io nemo keychain postgresql \
     redis-tools redis-server htop sqlitebrowser libusb-dev


# reconfigure locale
# remember to use `en_US.UTF-8 UTF-8`
sudo dpkg-reconfigure locales

# reconfigure postgresql
sudo cp ~/dotfiles/applications-config/etc/postgresql/10/main/pg_hba.conf \
     /etc/postgresql/10/main/pg_hba.conf
sudo systemctl restart postgresql
psql -U postgres -c "create user $USER;"
psql -U postgres -c "create database $USER;"

# install docker
sudo usermod -aG docker $USER

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# after this, should restart to change shell to zsh

# install exa
# ref https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04
## install rust compiler
curl https://sh.rustup.rs -sSf | sh
## TODO: find a way to fetch latest binary
wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
unzip exa-linux-x86_64-0.8.0.zip && rm exa-linux-x86_64-0.8.0.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa

# install nerd font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git &&
  nerd-fonts/install.sh &&
  mv nerd-fonts ~/workspace_misc/

# install teensy_loader_cli

# install find-cursor
git clone https://github.com/arp242/find-cursor.git && cd find-cursor &&
    make && sudo mkdir -p /usr/local/share/man/man1/ && sudo make install &&
    cd .. && mv find-cursor ~/workspace_misc/

# install alacritty
mkdir -p ~/.config/alacritty/
ln -sf $(realpath ~/dotfiles/alacritty.yml) ~/.config/alacritty/

# install vlc config
mkdir -p ~/.config/vlc
cp ~/dotfiles/vlc/vlcrc ~/.config/vlc/vlcrc

# install copyq config
rm -rf ~/.config/copyq
ln -sf $(realpath ~/dotfiles/copyq) ~/.config/copyq

# rofi
sudo cp /usr/bin/rofi /usr/local/bin/rofi
mkdir -p ~/.config/rofi/
ln -sf $(realpath ~/dotfiles/rofi/config.rasi) ~/.config/rofi/

# install snap packages
sudo snap install hub --classic

# install discord
wget --content-disposition https://discordapp.com/api/download\?platform\=linux\&format\=deb
sudo gdebi discord*.deb

# install caprine
curl -s https://api.github.com/repos/sindresorhus/caprine/releases/latest \
| grep "browser_download_url.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi caprine*.deb

# install slack
google-chrome https://slack.com/intl/en-vn/downloads/instructions/ubuntu
sudo gdebi slack-desktop*amd64.deb

# install viber
wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
sudo gdebi viber.deb

# install telegram
google-chrome https://telegram.org/dl/desktop/linux
tar -xvf tsetup.1.8.15.tar.xz
mv Telegram ~/bin/

# install skype
google-chrome https://www.skype.com/en/get-skype/
sudo gdebi skypeforlinux-64.deb

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

# install ruby/rbenv/bundle
# ref: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev \
     libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.4.4
gem install bundler

# install grc
git clone git@github.com:zealotnt/grc.git && mv grc ~/workspace_misc/ && cd ~/workspace_misc/grc && sudo ./install.sh && cd

# intall helm

# install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl &&
    chmod 777 kubectl && sudo mv kubectl /usr/local/bin

# install kubectl-krew
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.2/krew.{tar.gz,yaml}" &&
  tar zxvf krew.tar.gz &&
  ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install \
    --manifest=krew.yaml --archive=krew.tar.gz
)
# kubectl, kubens
kubectl krew install ctx
kubectl krew install ns

# install prometheus
cd /tmp
curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest \
| grep "browser_download_url.*linux-amd64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
prome_folder=$(extract prometheu*linux-amd64.tar.gz | sed -r -n 's/(.*)\/.*$/\1/p' | sed -n 1p)
# cd to folder
cd $prome_folder
sudo cp prometheus promtool tsdb /usr/bin

# install process-exporter
curl -s https://api.github.com/repos/ncabatoff/process-exporter/releases/latest \
| grep "browser_download_url.*linux_amd64.deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi process-exporter*_linux_amd64.deb

# install cadvisor
curl -s https://api.github.com/repos/google/cadvisor/releases/latest \
| grep "browser_download_url.*cadvisor" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
chmod 777 cadvisor
sudo mv cadvisor /usr/local/sbin/

# download node-exporter
# install step https://devopscube.com/monitor-linux-servers-prometheus-node-exporter/
cd /tmp
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest \
| grep "browser_download_url.*linux-amd64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
node_exporter_folder=$(extract node_exporter* | sed -r -n 's/(.*)\/.*$/\1/p' | sed -n 1p)
sudo mv $node_exporter_folder/node_exporter /usr/local/bin
sudo useradd -rs /bin/false node_exporter

# install nvidia-prometheus-exporter
go get github.com/mindprince/nvidia_gpu_prometheus_exporter
## then install systemd service (in this repo)

# install postgres exporter
go get github.com/wrouesnel/postgres_exporter && cd ${GOPATH-$HOME/go}/src/github.com/wrouesnel/postgres_exporter &&
    go run mage.go binary && sudo cp postgres_exporter /usr/local/bin
## then isntall systemd service

# install mpris-control
curl -s https://api.github.com/repos/BlackDex/mpris-control/releases/latest \
| grep "browser_download_url.*mpris-control" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i - && chmod 777 mpris-control && sudo mv mpris-control /usr/local/bin/

# install vimrc, vim-plug
mkdir -p ~/.config/nvim/
ln -sf $(realpath ~/dotfiles/.vimrc) ~/.config/nvim/init.vim
sudo chmod -R 777 ~/.local/share/nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# then go to vim, type: `PlugInstall`

# install goldendict config file
ln -sf $(realpath ~/dotfiles/goldendict/) ~/.goldendict

# install figlet-fonts
git -C ~/workspace_misc/ clone https://github.com/xero/figlet-fonts &&
    sudo mkdir -p /usr/share/figlet/fonts/ &&
    sudo cp ~/workspace_misc/figlet-fonts/* /usr/share/figlet/fonts/

# install jsonnet
git -C ~/workspace_misc/ clone https://github.com/google/jsonnet &&
    cd ~/workspace_misc/jsonnet/ && make && sudo make install && cd


# install calibre https://calibre-ebook.com/download_linux
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh \
| sudo sh /dev/stdin

# install qalculate
sudo snap install qalculate

# install firefox-dev
umake web firefox-dev --lang en-US

# vietnamese typing
# basically, dconf already setup the neccessary configuration for vietnamese typing
# but things still need to be configured correctly
# follow settings -> Region & Language -> Language -> {ubuntu will prompt to install the missing pieces}

# devops specific

# TODO: install golang
google-chrome https://golang.org/dl/
sudo tar -C /usr/local -xzf go*-amd64.tar.gz

pip install aws-mfa

## install govendor
go get -u github.com/kardianos/govendor

## install stern
mkdir -p $GOPATH/src/github.com/wercker
cd $GOPATH/src/github.com/wercker
git clone https://github.com/wercker/stern.git && cd stern
govendor sync
go install

## install sops https://github.com/mozilla/sops
go get -u go.mozilla.org/sops/cmd/sops
cd $GOPATH/src/go.mozilla.org/sops/
make install


# some usefull nodejs tools
sudo npm install --global public-ip-cli
sudo npm install -g tldr

# install noti
curl -s https://api.github.com/repos/variadico/noti/releases/latest \
| awk '/browser_download_url/ { print $2 }' \
| grep 'linux-amd64' | sed 's/"//g' \
| wget -i -

# install arandr
git -C ~/workspace_misc/ clone https://gitlab.com/arandr/arandr
cd ~/workspace_misc/arandr && sudo ./setup.py install

# install bat
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| grep "browser_download_url.*musl.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi bat-musl*.deb

# install fd-find
curl -s https://api.github.com/repos/sharkdp/fd/releases/latest \
| grep "browser_download_url.*musl.*amd64.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi fd-musl*.deb

# install smartmontools
curl -s https://api.github.com/repos/smartmontools/smartmontools/releases/latest \
| grep "browser_download_url.*tar.gz\"" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
tar -xvf smartmontools-7.0.tar.gz
cd smartmontools-7.0 && ./configure && make && sudo make install

# intall smartctl_exporter
go get github.com/Sheridan/smartctl_exporter &&
    cd $GOPATH/src/github.com/Sheridan/smartctl_exporter &&
    go build . &&
    sudo cp smartctl_exporter /usr/local/sbin/

# install openvpn-exporter
go get github.com/kumina/openvpn_exporter &&
    cd $GOPATH/src/github.com/kumina/openvpn_exporter &&
    go build . &&
    sudo cp openvpn_exporter /usr/local/sbin/

# clone, compile and install ncdu
git -C ~/workspace_misc/ clone git://g.blicky.net/ncdu.git/ &&
    cd ~/workspace_misc/ncdu &&
    autoreconf -i && ./configure &&
    make && sudo make install

# install minikube https://kubernetes.io/docs/tasks/tools/install-minikube/
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo install minikube /usr/local/bin/

# install sound-use-both-headphone-and-lineout
./pulseaudio/install.sh
# install autostart
./autostart/install.sh

# Emacs
## TODO: install all-the-icons
## for go-imenu
go get -u github.com/lukehoban/go-outline

#############################################################
# big fat heavy packages
sudo apt install -y kicad

