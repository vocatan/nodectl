#!/bin/bash
cd "$(dirname "$0")"

uname=`uname`
uname=${uname:0:7}
hostname=`hostname`
short_hostname=${hostname:0:4}

echo " "
echo "########## 1-setupInitial.sh ##################"
echo "start: BY `whoami`  ON  `date`  FROM  `pwd`"
echo " full hostname = $hostname"
echo "short hostname = $short_hostname"

if [ $uname == 'Linux' ]; then
  owner_group="$USER:$USER"
  yum --version > /dev/null 2>&1
  rc=$?
  if [ "$rc" == "0" ]; then
    YUM="y"
  else
    YUM="n"
  fi

  if [ "$YUM" == "n" ]; then
    PLATFORM=deb
    echo "## $PLATFORM ##"
    sudo apt install git net-tools wget curl zip git python3 openjdk-11-jdk-headless bzip2
    echo "## ONLY el8/9 supported for building binaries ###"
  else
    yum="dnf -y install"
    PLATFORM=`cat /etc/os-release | grep PLATFORM_ID | cut -d: -f2 | tr -d '\"'`
    echo "## $PLATFORM ##"
    sudo $yum git net-tools wget curl zip sqlite bzip2
    sudo $yum cpan
    sudo cpan FindBin
    sudo cpan IPC::Run
    sudo $yum epel-release

    sudo $yum java-11-openjdk-devel maven
    sudo alternatives --config java

    if [ "$short_hostname" == "test" ]; then
      echo "Goodbye TEST Setup!"
      exit 0
    fi

    if [ ! "$PLATFORM" == "el8" ] && [ ! "$PLATFORM" == "el9" ]; then
      echo " "
      echo "## ONLY el8 & el9 are supported for building binaries ###"
    else
      if [ "$PLATFORM" == "el8" ]; then
        sudo dnf config-manager --set-enabled powertools
      else
        sudo dnf config-manager --set-enabled crb
      fi
      sudo dnf -y groupinstall 'development tools'
      sudo $yum zlib-devel bzip2-devel \
        openssl-devel libxslt-devel libevent-devel c-ares-devel \
        perl-ExtUtils-Embed \
        pam-devel openldap-devel boost-devel 
      sudo $yum curl-devel chrpath clang-devel llvm-devel \
        cmake libxml2-devel 
      sudo $yum libedit-devel 
      sudo $yum *ossp-uuid*
      sudo $yum openjpeg2-devel libyaml libyaml-devel
      sudo $yum ncurses-compat-libs mysql-devel 
      sudo $yum unixODBC-devel protobuf-c-devel libyaml-devel
      sudo $yum mongo-c-driver-devel freetds-devel systemd-devel
      sudo $yum lz4-devel libzstd-devel krb5-devel
      if [ "$PLATFORM" == "el8" ]; then
        sudo $yum python39 python39-devel
	sudo yum remove python3
      else
	sudo $yum python3-devel
        sudo yum remove python3-pip
      fi 
      sudo $yum clang

      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
  fi

elif [ $uname == 'Darwin' ]; then
  owner_group="$USER:staff"
  if [ "$SHELL" != "/bin/bash" ]; then
    chsh -s /bin/bash
  fi
  brew --version > /dev/null 2>&1
  rc=$?
  if [ ! "$rc" == "0" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install pkg-config krb5 wget curl readline lz4 openssl@1.1 openldap ossp-uuid

else
  echo "$uname is unsupported"
  exit 1
fi

sudo mkdir -p /opt/pgbin-build
sudo mkdir -p /opt/pgbin-build/pgbin/bin
sudo chown -R $owner_group /opt/pgbin-build
sudo mkdir -p /opt/pgcomponent
sudo chown $owner_group /opt/pgcomponent
mkdir -p ~/dev
cd ~/dev
mkdir -p in
mkdir -p out
mkdir -p history

cd ~
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
rm get-pip.py

aws --version > /dev/null 2>&1 
rc=$?
if [ ! "$rc" == "0" ]; then
  pip3 install awscli
  mkdir -p ~/.aws
  cd ~/.aws
  touch config
  # vi config
  chmod 600 config
fi

cd ~/dev/nodectl
if [ -f ~/.bashrc ]; then
  bf=~/.bashrc
else
  bf=~/.bash_profile
fi

## don't append if already there
grep NC $bf > /dev/null 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  cat bash_profile >> $bf
fi

echo ""
echo "Goodbye!"
