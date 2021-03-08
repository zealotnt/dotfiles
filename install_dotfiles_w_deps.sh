#!/bin/bash

# if network is slow, and we dont want to pass sudoers password many times
# ref - https://stackoverflow.com/questions/323957/how-do-i-edit-etc-sudoers-from-a-script
#     - https://www.tecmint.com/set-sudo-password-timeout-session-longer-linux/
# echo 'Defaults        env_reset,timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo

# verbose progress printing
set -x

# disable auto update first
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

CURUSER=$(w | grep gdm | awk '{print $1}')
RUSER_UID=$(id -u ${CURUSER})
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# no dimming, turn off screen when installing
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set com.ubuntu.touch.system auto-brightness "false"
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.desktop.session idle-delay 0
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.power idle-dim "false"
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled "true"
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
sudo -u ${CURUSER} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll "false"

# disable auto update first
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

sudo apt update
sudo apt install -y git curl zsh
sudo chsh -s /usr/bin/zsh $USER

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# insstall oh-my-tmux: gpakosz/.tmux
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/
touch ~/.tmux.conf.local
ln -sf $HOME/dotfiles/.tmux.conf.local  ~/

# install tpm for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git -C ~/.tmux/ clone https://github.com/jonmosco/kube-tmux

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# zsh-plugins
git clone https://github.com/popstas/zsh-command-time.git ~/.oh-my-zsh/custom/plugins/command-time
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/wulfgarpro/history-sync.git ~/.oh-my-zsh/plugins/history-sync
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open

# other utils
git clone https://github.com/alexppg/helmenv.git ~/.helmenv

source ~/dotfiles/install_dotfiles.sh

git submodule init
git submodule update


############################################################################
# install keyring, pgp things
. ~/dotfiles/apt-clone/import_sources.sh
sudo apt update

# install apt-package
sudo apt install -y moreutils jq tmux google-chrome-stable emacs26 rofi ruby \
     gdebi apt-transport-https sublime-merge dconf-editor gnome-tweak-tool code \
     xdotool tree p7zip-full pavucontrol indicator-sound-switcher ibus-unikey \
     blueman neovim network-manager-openvpn figlet goldendict silversearcher-ag \
     copyq minicom neofetch nodejs npm nodejs nnn alacritty ubuntu-make \
     libdbus-1-dev `# requires for mpris-control` \
     python-dev python-pip python3-dev python3-pip `# requies for neovim related` \
     libx11-dev apt-file libxdamage-dev libxrender-dev libxext-dev `# requires to compile find-cursor` \
     vlc gnupg-agent docker-ce docker-ce-cli containerd.io nemo keychain postgresql \
     redis-tools redis-server htop sqlitebrowser libusb-dev exuberant-ctags detox \
     openssh-server gparted iotop libpam-google-authenticator libnss3-tools \
     python-docutils python3-docutils `# requires for arandr` \
     libavcodec-dev pulseaudio-module-bluetooth `# install bluetooth aptx,etc...` \
     system-config-samba samba samba-common-bin cmake grsync libtool libnemo-extension-dev \
     yarn socat libsqlite3-dev dialog guvcview ethtool ofono ofono-phonesim ofono-phonesim-autostart \
     libpq-dev i3 compton feh yad xcape wireguard imwheel acpitool acpi mpv

############################################################################
# install editor tools so that we can effectively follow fresh_install.sh
# install bat
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| grep "browser_download_url.*musl.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi -n bat-musl*.deb
rm bat-musl*.deb

# install fd-find
curl -s https://api.github.com/repos/sharkdp/fd/releases/latest \
| grep "browser_download_url.*musl.*amd64.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi -n fd-musl*.deb
rm fd-musl*.deb

# install playerctl
curl -s https://api.github.com/repos/altdesktop/playerctl/releases/latest \
| grep "browser_download_url.*amd64.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi -n playerctl*.deb
rm playerctl*.deb

# install mpris-control
curl -s https://api.github.com/repos/BlackDex/mpris-control/releases/latest \
| grep "browser_download_url.*mpris-control" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i - && chmod 777 mpris-control && sudo mv mpris-control /usr/local/bin/

# install rustup
## install rust compiler
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# i3 dependancies
cargo install run-or-raise

# install i3 config
mkdir -p ~/.config/i3
ln -sf $(realpath ~/dotfiles/i3-config) ~/.config/i3/config

# install i3blocks and i3 dependancies/utils
git -C /tmp/ clone https://github.com/vivien/i3blocks &&
    cd /tmp/i3blocks &&
    ./autogen.sh &&
    ./configure &&
    make &&
    sudo make install
sudo mkdir /usr/share/i3blocks
sudo cp ~/dotfiles/i3/i3blocks-blocklets/* /usr/share/i3blocks
ln -sf $(realpath ~/dotfiles/i3blocks.conf) ~/.config/i3/i3blocks.conf
## i3-utils
sudo cp ~/dotfiles/i3/i3-utils/* /usr/local/bin

# install alacritty
mkdir -p ~/.config/alacritty/
ln -sf $(realpath ~/dotfiles/alacritty.yml) ~/.config/alacritty/

# install vimrc, vim-plug
mkdir -p ~/.config/nvim/
ln -sf $(realpath ~/dotfiles/.vimrc) ~/.config/nvim/init.vim
sudo chmod -R 777 ~/.local/share/nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# then go to vim, type: `PlugInstall` or use this
nvim --headless +PlugInstall +qall

# rofi
sudo cp /usr/bin/rofi /usr/local/bin/rofi
mkdir -p ~/.config/rofi/
ln -sf $(realpath ~/dotfiles/rofi/config.rasi) ~/.config/rofi/

# install vlc config
mkdir -p ~/.config/vlc
ln -sf $(realpath ~/dotfiles/vlc/vlcrc) ~/.config/vlc/vlcrc

# install sublime-merge config
mkdir -p ~/.config/sublime-merge/Packages/User
for i in ~/dotfiles/sublime-merge/*; do ln -sf $i ~/.config/sublime-merge/Packages/User ; done

# install copyq config
rm -rf ~/.config/copyq
ln -sf $(realpath ~/dotfiles/copyq) ~/.config/copyq

# install goldendict config file
ln -sf $(realpath ~/dotfiles/goldendict/) ~/.goldendict

# add mpv config files
mkdir -p ~/.config/mpv
ln -sf $(realpath ~/dotfiles/mpv.conf) ~/.config/mpv/mpv.conf
ln -sf $(realpath ~/dotfiles/mpv-input.conf) ~/.config/mpv/input.conf

# install calibre https://calibre-ebook.com/download_linux
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh \
| sudo sh /dev/stdin

# install ruby/rbenv/bundle
# ref: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04
sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev \
     libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.4.4
rbenv install 2.6.6
gem install bundler

# intall helm3
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

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
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# kubectl, kubens
kubectl krew install ctx
kubectl krew install ns

# install minikube https://kubernetes.io/docs/tasks/tools/install-minikube/
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo install minikube /usr/local/bin/

# install exa
# ref https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04
## TODO: find a way to fetch latest binary
wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
unzip exa-linux-x86_64-0.8.0.zip && rm exa-linux-x86_64-0.8.0.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa

# install youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

# install docker permission
sudo usermod -aG docker $USER

# snap apps

# install qalculate
sudo snap install qalculate

# install snap packages
sudo snap install hub --classic

# user related things
sudo usermod -aG bluetooth pulse

# config touchpad
# ref https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/
sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lrm"
        Option "ScrollMethod" "twofinger"
EndSection
EOF

# pip packages
pip install aws-mfa
pip install awscli
pip install aws-shell

# some usefull nodejs tools
sudo npm install --global public-ip-cli
sudo npm install -g tldr

# config for gtk
mkdir -p ~/.config/gtk-3.0/
cp ~/dotfiles/gtk/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/

# install old packages
OLD_HOME_DEV=$(sudo blkid | grep Old-Home | sed -r -n 's/(.*)\:.*/\1/p')
[ ! -z "$OLD_HOME_DEV" ] &&
(
  mkdir ~/Old-Home
  sudo mount $OLD_HOME_DEV ~/Old-Home

  WORKSPACE_FOLDER=~/Old-Home/zealot
  ln -sf $(realpath $WORKSPACE_FOLDER/workspace_mine) $HOME
  ln -sf $(realpath $WORKSPACE_FOLDER/workspace_misc) $HOME
  ln -sf $(realpath $WORKSPACE_FOLDER/workspace_eh) $HOME

  # install nerd-fonts
  ~/workspace_misc/nerd-fonts/install.sh

  ln -sf $(realpath $WORKSPACE_FOLDER/.emacs.d) $HOME
)

