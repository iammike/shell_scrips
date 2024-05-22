#!/bin/bash

# Get the remote URL
remote_url=$(git config --get remote.origin.url)

# Transform the remote URL to a web URL
if [[ $remote_url == git@github.com:* ]]; then
  # SSH URL for GitHub
  web_url=${remote_url/git@github.com:/https:\/\/github.com\/}
elif [[ $remote_url == https://github.com/* ]]; then
  # HTTPS URL for GitHub
  web_url=$remote_url
elif [[ $remote_url == https://stash.prod.netflix.net:* ]]; then
  # HTTPS URL for Stash/Bitbucket Server
  # Extract the project and repo names from the URL
  project_repo=$(echo $remote_url | sed -e 's|https://stash.prod.netflix.net:7006/scm/||')
  project=$(echo $project_repo | cut -d'/' -f1 | tr '[:lower:]' '[:upper:]')
  repo=$(echo $project_repo | cut -d'/' -f2 | sed 's|\.git$||')
  web_url="https://stash.corp.netflix.com/projects/$project/repos/$repo/browse"
else
  echo "Unsupported remote URL format: $remote_url"
  exit 1
fi

# Open the URL in the default web browser
if which xdg-open > /dev/null; then
  xdg-open "$web_url"
elif which open > /dev/null; then
  open "$web_url"
else
  echo "Could not detect the web browser to use."
  exit 1
fi