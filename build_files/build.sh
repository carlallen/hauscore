#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux zsh python3-pip fastfetch cachefilesd

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Enable System Unit Files

systemctl enable docker.socket
systemctl enable docker.service
systemctl enable cachefilesd

### Disable systemd-resolved
systemctl disable systemd-resolved.service
sed -i '/\[main\]/a dns=default' /etc/NetworkManager/NetworkManager.conf
rm /etc/resolv.conf

### Set up fastfetch on login shell
echo "/usr/bin/fastfetch" >> /etc/profile.d/fastfetch.sh
