#!/bin/bash


if [[ $? != 0 ]]; then
  echo "Usage:"
  echo " install_service.sh <service file to install to systemd>"
  return
fi

SERVICE_FILE=$1
sudo ln -sf $(realpath $SERVICE_FILE) /etc/systemd/system/
sudo systemctl daemon-reload

# ref https://stackoverflow.com/questions/125281/how-do-i-remove-the-file-suffix-and-path-portion-from-a-path-string-in-bash
sudo systemctl start ${SERVICE_FILE%.service}
sudo systemctl enable ${SERVICE_FILE%.service}
systemctl status ${SERVICE_FILE%.service}
