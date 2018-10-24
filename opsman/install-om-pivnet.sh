#!/bin/sh

echo "installing om cli"

curl -s https://api.github.com/repos/pivotal-cf/om/releases/latest \
| grep "browser_download_url.*linux" \
| cut -d '"' -f 4 \
| wget -qi -
chmod +x om-linux
sudo mv om-linux /usr/local/bin/om

echo "installing pivnet cli"
curl -s https://api.github.com/repos/pivotal-cf/pivnet-cli/releases/latest \
| grep "browser_download_url.*linux" \
| cut -d '"' -f 4 \
| wget -qi -
mv pivnet-linux-* pivnet
chmod +x pivnet
mv pivnet /usr/local/bin/pivnet