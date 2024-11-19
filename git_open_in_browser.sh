#!/bin/bash
# Contact Michael Collins with questions, comments, changes, etc.

# Get the remote URL
remote_url=$(git config --get remote.origin.url)

# Transform the remote URL to a web URL
if [[ $remote_url == git@github.com:* ]]; then
  # SSH URL for GitHub
  web_url=${remote_url/git@github.com:/https:\/\/github.com\/}
elif [[ $remote_url == https://github.com/* ]]; then
  # HTTPS URL for GitHub
  web_url=$remote_url
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
