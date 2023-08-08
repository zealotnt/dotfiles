#!/bin/bash

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
sudo gdebi -n process-exporter*_linux_amd64.deb

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
