#!/bin/bash


if [[ $# != 1 ]]; then
  echo "Usage:"
  echo " install_service.sh <service file to install to systemd>"
  exit 1
fi

SERVICE_FILE=$1
sudo rm /etc/systemd/system/${SERVICE_FILE}
sudo cp $(realpath $SERVICE_FILE) /etc/systemd/system/
sudo systemctl daemon-reload

# ref https://stackoverflow.com/questions/125281/how-do-i-remove-the-file-suffix-and-path-portion-from-a-path-string-in-bash
echo "sudo systemctl start ${SERVICE_FILE%.service}"
echo "sudo systemctl enable ${SERVICE_FILE%.service}"
sudo systemctl start ${SERVICE_FILE%.service}
sudo systemctl enable ${SERVICE_FILE%.service}

systemctl status ${SERVICE_FILE%.service}

