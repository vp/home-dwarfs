#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 1>&2
   exit 1
fi

is_Raspberry=$(cat /proc/device-tree/model | awk  '{print $1}')
if [ "x${is_Raspberry}" != "xRaspberry" ] ; then
  echo "Sorry, this drivers only works on raspberry pi"
  exit 1
fi

ver="0.3"


# we create a dir with this version to ensure that 'dkms remove' won't delete
# the sources during kernel updates
marker="0.0.0"


# locate currently installed kernels (may be different to running kernel if
# it's just been updated)
kernels=$(ls /lib/modules | sed "s/^/-k /")
uname_r=$(uname -r)

function install_module {
  src=$1
  mod=$2

  if [[ -d /var/lib/dkms/$mod/$ver/$marker ]]; then
    rmdir /var/lib/dkms/$mod/$ver/$marker
  fi

  if [[ -e /usr/src/$mod-$ver || -e /var/lib/dkms/$mod/$ver ]]; then
    dkms remove --force -m $mod -v $ver --all
    rm -rf /usr/src/$mod-$ver
  fi
  mkdir -p /usr/src/$mod-$ver
  cp -a $src/* /usr/src/$mod-$ver/
  dkms add -m $mod -v $ver
  dkms build $kernels -m $mod -v $ver && dkms install --force $kernels -m $mod -v $ver

  mkdir -p /var/lib/dkms/$mod/$ver/$marker
}

install_module "./" "seeed-voicecard"


# install dtbos
cp seeed-2mic-voicecard.dtbo /boot/overlays
cp seeed-4mic-voicecard.dtbo /boot/overlays
cp seeed-8mic-voicecard.dtbo /boot/overlays

#install alsa plugins
# no need this plugin now
# install -D ac108_plugin/libasound_module_pcm_ac108.so   /usr/lib/arm-linux-gnueabihf/alsa-lib/libasound_module_pcm_ac108.so

#set kernel moduels
grep -q "snd-soc-simple-card" /etc/modules || \
  echo "snd-soc-simple-card" >> /etc/modules
grep -q "snd-soc-ac108" /etc/modules || \
  echo "snd-soc-ac108" >> /etc/modules
grep -q "snd-soc-wm8960" /etc/modules || \
  echo "snd-soc-wm8960" >> /etc/modules  

cp seeed-voicecard /usr/bin/
