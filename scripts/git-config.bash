#!/usr/bin/env bash

echo "Configuring git..."
git config user.email $GIT_USER_EMAIL
git config user.name $GIT_USER_NAME
echo "Done!"