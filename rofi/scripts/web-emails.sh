#!/usr/bin/env bash

BROWSER=google-chrome
BROWSER_FLAG=""
PWD=$(dirname "$BASH_SOURCE")
CACHE_FILE=$PWD/cache/github-repos.cache

declare -A EmailMaps
EmailMaps[web-gmail-default]="https://mail.google.com/mail/u/0/#inbox"
EmailMaps[web-gmail-work-eh]="https://mail.google.com/mail/u/1/#inbox"

get_emails() {
printf 'web-gmail-default\nweb-gmail-work-eh'
}

open_email() {
  (${BROWSER} ${BROWSER_FLAG} "${EmailMaps[$1]}" &) > /dev/null 2>&1
}

main() {
  if [ -z "$1" ]; then
    get_emails
  else
    open_email "$1"
  fi
}

main "$@"

exit 0
