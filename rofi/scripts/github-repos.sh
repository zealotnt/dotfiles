#!/usr/bin/env bash

PWD=$(dirname "$BASH_SOURCE")
CACHE_FILE=$PWD/cache/github-repos.cache

# Get all the repositories for the user with curl and GitHub API
fetch_repositories() {
  rm $CACHE_FILE
  touch $CACHE_FILE
  NUM_PAGES=$(curl -s -I -H "authorization: token $EH_GITHUB_ZEALOT_TOKEN" "https://api.github.com/user/repos?per_page=100&page=1" | sed -r -n '/^Link:/ s/.*page=([0-9]+).*/\1/p')
  IDX=1
  while [ $IDX -le $NUM_PAGES ] 
  do
    curl -s -H "authorization: token $EH_GITHUB_ZEALOT_TOKEN" "https://api.github.com/user/repos?per_page=100&page=$IDX" | jq -r 'map(.full_name) | join("\n")' >> $CACHE_FILE
    IDX=$(( $IDX + 1 ))
  done
}

main() {
  fetch_repositories
}

main

exit 0
