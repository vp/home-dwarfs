#!/bin/bash

: <<'DISCLAIMER'

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

This script is licensed under the terms of the MIT license.
Unless otherwise noted, code reproduced herein
was written for this script.

DISCLAIMER


gitreponame="seeed-voicecard" # the name of the git project repo
gitusername="respeaker" # the name of the git user to fetch repo from
gitrepobranch="install" # repo branch to checkout
gitrepotop="root" # the name of the dir to base repo from
gitrepoclone="yes" # whether the git repo is to be cloned locally
gitclonedir="source" # the name of the local dir for repo
topdir="seeed" # the name of the top level directory
repoclean="no" # whether any git repo clone found should be cleaned up
repoinstall="yes" # whether the library should be installed from repo

installdir="/$topdir"

echo "installdir is $installdir"

newline() {
    echo ""
}

#is_Raspberry=$(cat /proc/device-tree/model | awk  '{print $1}')
#if [ "x${is_Raspberry}" != "xRaspberry" ] ; then
#  echo "Sorry, this drivers only works on raspberry pi"
#  exit 1
#fi


if [ $gitrepoclone == "yes" ]; then
    [ -d $installdir ] || mkdir -p $installdir
fi


if [ $gitrepoclone == "yes" ]; then
    if ! command -v git > /dev/null; then
        apt_pkg_install git
    fi
    if [ $gitclonedir == "source" ]; then
        gitclonedir=$gitreponame
    fi
    if [ $repoclean == "yes" ]; then
        rm -Rf $installdir/$gitclonedir
    fi
    if [ -d $installdir/$gitclonedir ]; then
        newline && echo "Github repo already present. Updating..."
        cd $installdir/$gitclonedir && git pull
    else
        newline && echo "Cloning Github repo locally..."
        cd $installdir
        if [ $gitrepobranch != "master" ]; then
            git clone https://github.com/$gitusername/$gitreponame $gitclonedir -b $gitrepobranch
        else
            git clone --depth=1 https://github.com/$gitusername/$gitreponame $gitclonedir
        fi
    fi
fi

newline && echo "Installing..." && newline
cd $installdir/$gitreponame

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
  
#set dtoverlays
sed -i -e 's:#dtparam=i2c_arm=on:dtparam=i2c_arm=on:g'  /boot/config.txt || true
grep -q "dtoverlay=i2s-mmap" /boot/config.txt || \
  echo "dtoverlay=i2s-mmap" >> /boot/config.txt


grep -q "dtparam=i2s=on" /boot/config.txt || \
  echo "dtparam=i2s=on" >> /boot/config.txt

#install config files
mkdir /etc/voicecard || true
cp *.conf /etc/voicecard
cp *.state /etc/voicecard

cp seeed-voicecard /usr/bin/

newline
