#!/bin/sh

echo '-----'
echo 'Preparing environment for building layer...'
echo '-----'

echo 'Updating the system...'
sudo yum update -y

echo 'Installing packages... (this might take a couple minutes)'
sudo yum install -y "@Development Tools" gcc-c++ cairo-devel pango-devel libjpeg-turbo-devel giflib-devel librsvg2-devel pango-devel bzip2-devel jq
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

echo 'Done!'
