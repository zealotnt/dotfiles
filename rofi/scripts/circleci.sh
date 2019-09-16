#!/usr/bin/env bash

BROWSER=google-chrome
BROWSER_FLAG=""
PWD=$(dirname "$BASH_SOURCE")
CACHE_FILE=$PWD/cache/github-repos.cache

get_repositories() {
  cat $CACHE_FILE | grep Thinkei
}

open_repository() {
  (${BROWSER} --new-tab https://circleci.com/gh/"$1" &) > /dev/null 2>&1
}

main() {
  if [ -z "$1" ]; then
    get_repositories
  else
    open_repository "$1"
  fi
}

main "$@"

exit 0
