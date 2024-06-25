#!/bin/bash

# exit when any command fails
set -e

# Check if new version is provided
if [ -z "$1" ]; then
  echo "No version provided"
  exit 1
fi

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.23.3 philipepi/nginx:$new_ver

# Push new version to dockerhub
docker push philipepi/nginx:$new_ver

# Create temporary folder
mkdir -p /home/linux/tmp_dir
export TMP_DIR=/home/linux/tmp_dir

# Clone GitHub repo
git clone git@github.com:philipecella/lesson-158.git $TMP_DIR

# Update image tag
sed -i -e "s/philipepi\/nginx:.*/philipepi\/nginx:$new_ver/g" $TMP_DIR/my-app/1-deployment.yaml

# Commit and push
cd $TMP_DIR
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $TMP_DIR
