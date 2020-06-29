#!/bin/bash

mkdir ~/bin/

ln -sf $(realpath Old-Home/zealot/workspace_mine) .
ln -sf $(realpath Old-Home/zealot/workspace_misc) .
ln -sf $(realpath Old-Home/zealot/workspace_eh) .

cp -rp Old-Root/home/zealot/.ssh .
cp -rp Old-Root/home/zealot/.aws .
cp -rp Old-Root/home/zealot/.kube .

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

# install docker
sudo usermod -aG docker $USER

# install nerd font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git &&
  nerd-fonts/install.sh &&
  mv nerd-fonts ~/workspace_misc/

# install teensy_loader_cli

# install find-cursor
git clone https://github.com/arp242/find-cursor.git && cd find-cursor &&
    make && sudo mkdir -p /usr/local/share/man/man1/ && sudo make install &&
    cd .. && mv find-cursor ~/workspace_misc/

# install vlc config
mkdir -p ~/.config/vlc
ln -sf $(realpath ~/dotfiles/vlc/vlcrc) ~/.config/vlc/vlcrc

# install sublime-merge config
mkdir -p ~/.config/sublime-merge/Packages/User
for i in ~/dotfiles/sublime-merge/*; do ln -sf $i ~/.config/sublime-merge/Packages/User ; done

# install copyq config
rm -rf ~/.config/copyq
ln -sf $(realpath ~/dotfiles/copyq) ~/.config/copyq

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
wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz
tar -xvf helm*.tar.gz
sudo mv linux-amd64/helm linux-amd64/tiller /usr/local/bin

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
prome_folder=$(tar -xvf prometheu*linux-amd64.tar.gz | sed -r -n 's/(.*)\/.*$/\1/p' | sed -n 1p)
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

# install libreoffice
google-chrome https://www.libreoffice.org/donate/dl/deb-x86_64/6.3.4/en-US/LibreOffice_6.3.4_Linux_x86-64_deb.tar.gz
x LibreOffice_6.3.4_Linux_x86-64_deb.tar.gz
cd LibreOffice_6.3.4_Linux_x86-64_deb/DEBS
sudo dpkg -i *.deb

# TODO: install golang
google-chrome https://golang.org/dl/
sudo tar -C /usr/local -xzf go*-amd64.tar.gz

pip install aws-mfa
pip install awscli
pip install aws-shell

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

# install fd-find
curl -s https://api.github.com/repos/sharkdp/fd/releases/latest \
| grep "browser_download_url.*musl.*amd64.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi fd-musl*.deb

# install playerctl
curl -s https://api.github.com/repos/altdesktop/playerctl/releases/latest \
| grep "browser_download_url.*amd64.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
sudo gdebi playerctl*.deb

# install smartmontools
curl -s https://api.github.com/repos/smartmontools/smartmontools/releases/latest \
| grep "browser_download_url.*tar.gz\"" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
extract_folder=$(tar -xvf smartmontools-*.tar.gz | sed -r -n 's/(.*)\/.*$/\1/p' | sed -n 1p)
cd $extract_folder && ./configure && make && sudo make install

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
~/dotfiles/pulseaudio/install.sh
# install autostart
~/dotfiles/autostart/install.sh

# Emacs
## install all-the-icons
emacsclient --eval "(all-the-icons-install-fonts t)"
## for go-imenu
go get -u github.com/lukehoban/go-outline

#############################################################
# big fat heavy packages
sudo apt install -y kicad

