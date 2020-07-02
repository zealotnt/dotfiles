#!/bin/bash

sudo apt install -y git curl zsh
sudo chsh -s /usr/bin/zsh root

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# insstall oh-my-tmux: gpakosz/.tmux
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/
cp ~/.tmux/.tmux.conf.local .
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
git clone git@github.com:wulfgarpro/history-sync.git ~/.oh-my-zsh/plugins/history-sync
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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
     copyq minicom neofetch nodejs npm nodejs nnn alacritty spotify-client ubuntu-make \
     libdbus-1-dev `# requires for mpris-control` \
     python-dev python-pip python3-dev python3-pip `# requies for neovim related` \
     libx11-dev apt-file libxdamage-dev libxrender-dev libxext-dev `# requires to compile find-cursor` \
     vlc gnupg-agent docker-ce docker-ce-cli containerd.io nemo keychain postgresql \
     redis-tools redis-server htop sqlitebrowser libusb-dev exuberant-ctags detox \
     openssh-server gparted iotop libpam-google-authenticator libnss3-tools \
     python-docutils python3-docutils `# requires for arandr` \
     libavcodec-dev pulseaudio-module-bluetooth `# install bluetooth aptx,etc...` \
     system-config-samba samba samba-common-bin cmake grsync libtool libnemo-extension-dev \
     yarn socat libsqlite3-dev dialog

############################################################################
# install editor tools so that we can effectively follow fresh_install.sh
# install bat
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| grep "browser_download_url.*musl.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi bat-musl*.deb
rm bat-musl*.deb

# install alacritty
mkdir -p ~/.config/alacritty/
ln -sf $(realpath ~/dotfiles/alacritty.yml) ~/.config/alacritty/

# install vimrc, vim-plug
mkdir -p ~/.config/nvim/
ln -sf $(realpath ~/dotfiles/.vimrc) ~/.config/nvim/init.vim
sudo chmod -R 777 ~/.local/share/nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# then go to vim, type: `PlugInstall`

# rofi
sudo cp /usr/bin/rofi /usr/local/bin/rofi
mkdir -p ~/.config/rofi/
ln -sf $(realpath ~/dotfiles/rofi/config.rasi) ~/.config/rofi/

# install exa
# ref https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04
## install rust compiler
curl https://sh.rustup.rs -sSf | sh
## TODO: find a way to fetch latest binary
wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
unzip exa-linux-x86_64-0.8.0.zip && rm exa-linux-x86_64-0.8.0.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa

# snap apps

# install qalculate
sudo snap install qalculate

# install snap packages
sudo snap install hub --classic

