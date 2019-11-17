#!/bin/bash

for f in *.service
do
  echo "sudo ln -sf \"$(realpath $f)\" /etc/systemd/system/"
  # sudo ln -sf "$(realpath $f)" /etc/systemd/system/
done

# sudo systemctl daemon-reload

# ref https://stackoverflow.com/questions/125281/how-do-i-remove-the-file-suffix-and-path-portion-from-a-path-string-in-bash
for f in *.service
do
  echo "sudo systemctl start ${f%.service}"
  echo "sudo systemctl enable ${f%.service}"
done
