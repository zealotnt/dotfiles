#!/bin/bash

#############################################################################3
# devops specific
#############################################################################3

# install jsonnet
git -C ~/workspace_misc/ clone https://github.com/google/jsonnet &&
    cd ~/workspace_misc/jsonnet/ && make && sudo make install && cd

# install firefox-dev
umake web firefox-dev --lang en-U

# intall helm
# helm2 is deprecated
# wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz
# tar -xvf helm*.tar.gz
# sudo mv linux-amd64/helm linux-amd64/tiller /usr/local/bin

## install sops https://github.com/mozilla/sops
go get -u go.mozilla.org/sops/cmd/sops
cd $GOPATH/src/go.mozilla.org/sops/
make install

## install stern
mkdir -p $GOPATH/src/github.com/wercker
cd $GOPATH/src/github.com/wercker
git clone https://github.com/wercker/stern.git && cd stern
govendor sync
go install
