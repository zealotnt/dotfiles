#!/bin/bash


if [[ $# != 1 ]]; then
  echo "Usage:"
  echo " install_service.sh <service file to install to systemd>"
  exit 1
fi

mkdir -i ~/.config/systemd/user/

SERVICE_FILE=$1
SERVICE_FILE_NAME=$(basename $SERVICE_FILE)
PATH_TO_COPY="~/.config/systemd/user"

echo "rm $PATH_TO_COPY/$SERVICE_FILE_NAME"
rm $PATH_TO_COPY/$SERVICE_FILE_NAME
echo "cp $(realpath $SERVICE_FILE) $PATH_TO_COPY"
cp $(realpath $SERVICE_FILE) $PATH_TO_COPY

systemctl --user daemon-reload

echo "systemctl --user daemon-reload"
systemctl --user daemon-reload

echo "systemctl start ${SERVICE_FILE%.service}"
systemctl start --user ${SERVICE_FILE%.service}

echo "systemctl enable ${SERVICE_FILE%.service}"
systemctl enable --user ${SERVICE_FILE%.service}

echo "systemctl status ${SERVICE_FILE%.service}"
systemctl status --user ${SERVICE_FILE%.service}

