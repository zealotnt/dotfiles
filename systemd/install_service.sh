#!/bin/bash


if [[ $# != 1 ]]; then
  echo "Usage:"
  echo " install_service.sh <service file to install to systemd>"
  exit 1
fi

SERVICE_FILE=$1
SERVICE_FILE_NAME=$(basename $SERVICE_FILE)
echo "sudo rm /etc/systemd/system/$SERVICE_FILE_NAME"
sudo rm /etc/systemd/system/$SERVICE_FILE_NAME
# echo "sudo ln -s $(realpath $SERVICE_FILE) /etc/systemd/system/"
# sudo ln -s $(realpath $SERVICE_FILE) /etc/systemd/system/
echo "sudo cp $(realpath $SERVICE_FILE) /etc/systemd/system/"
sudo cp $(realpath $SERVICE_FILE) /etc/systemd/system/
sudo systemctl daemon-reload

# ref https://stackoverflow.com/questions/125281/how-do-i-remove-the-file-suffix-and-path-portion-from-a-path-string-in-bash
echo "sudo systemctl start ${SERVICE_FILE%.service}"
echo "sudo systemctl enable ${SERVICE_FILE%.service}"
sudo systemctl start ${SERVICE_FILE%.service}
sudo systemctl enable ${SERVICE_FILE%.service}

echo "systemctl status ${SERVICE_FILE%.service}"
systemctl status ${SERVICE_FILE%.service}

