#!/bin/bash

mkdir ~/workspace_mine/
mkdir ~/workspace_misc/

. ~/dotfiles/apt-key/set-to-machine.sh

# install essential tools
sudo apt install -y git zsh curl zsh tmux google-chrome-stable emacs26 rofi ruby \
     gdebi apt-transport-https sublime-merge dconf-editor gnome-tweak-tool code \
     xdotool tree p7zip-full pavucontrol indicator-sound-switcher ibus-unikey \
     blueman neovim network-manager-openvpn figlet goldendict silversearcher-ag \
     copyq \
     libdbus-1-dev \ # requires for mpris-control
     python-dev python-pip python3-dev python3-pip \ # requies for neovim related
     libx11-dev apt-file libxdamage-dev libxrender-dev libxext-dev # requires to compile find-cursor

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

# install find-cursor
git clone https://github.com/arp242/find-cursor.git && cd find-cursor &&
    make && sudo make install && cd .. && mv find-cursor ~/workspace_misc/

# install alacritty
sudo apt install alacritty
ln -sf $(realpath ~/dotfiles/alacritty.yml) ~/.config/alacritty/

# rofi
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

# install slack

# install spotify, cause we already add gpg key of its server, then just apt install
sudo apt-get install spotify-client

# install gnome-extensions
mkdir -p ~/.local/share/gnome-shell/extensions

## unite
## https://extensions.gnome.org/extension/1287/unite/
## gtile
## https://extensions.gnome.org/extension/28/gtile/

# big fat heavy packages
sudo apt install -y kicad

sudo apt-get install git pkg-config build-essential qt4-qmake \
     libvorbis-dev zlib1g-dev libhunspell-dev x11proto-record-dev \
     libqt4-dev libqtwebkit-dev libxtst-dev liblzo2-dev libbz2-dev \
     libao-dev libavutil-dev libavformat-dev libtiff5-dev libeb16-dev # for compiling goldendict
sudo apt-get install git pkg-config build-essential qt5-qmake \
     libvorbis-dev zlib1g-dev libhunspell-dev x11proto-record-dev \
     qtdeclarative5-dev libxtst-dev liblzo2-dev libbz2-dev \
     libao-dev libavutil-dev libavformat-dev libtiff5-dev libeb16-dev \
     libqt5webkit5-dev libqt5svg5-dev libqt5x11extras5-dev qttools5-dev \
     qttools5-dev-tools qtmultimedia5-dev libqt5multimedia5-plugins # goldendict

# some misc command
## enable control nvidia-card-fan-speed
## sudo nvidia-xconfig -a --cool-bits=28

# install grc
git clone git@github.com:zealotnt/grc.git && mv grc ~/workspace_misc/ && cd ~/workspace_misc/grc && sudo ./install.sh && cd

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
curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest \
| grep "browser_download_url.*linux-amd64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -

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
echo /etc/systemd/system/node_exporter.service

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
git -C ~/workspace_misc/ https://github.com/xero/figlet-fonts && sudo mkdir -p /usr/share/figlet/fonts/ && sudo cp ~/workspace_misc/figlet-fonts/* /usr/share/figlet/fonts/

# vietnamese typing
# basically, dconf already setup the neccessary configuration for vietnamese typing
# but things still need to be configured correctly
# follow settings -> Region & Language -> Language -> {ubuntu will prompt to install the missing pieces}

# devops specific
# install .kube credential folder
# install openvpn
