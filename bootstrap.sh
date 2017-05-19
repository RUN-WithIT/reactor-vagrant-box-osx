#!/bin/bash

# http://stackoverflow.com/a/4025065
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

# Install basic dependencies.
brew install wget cmake emacs
brew install gnu-sed --with-default-names
brew install flex
brew install guile
brew install mono

bison_missing=`command -v bison >/dev/null 2>&1 || echo 1`

bison_version_invalid=""
if [ -z "$bison_missing" ]; then
    bison_version_str=`bison --version | grep "bison (GNU Bison)"`
    bison_version=`echo ${bison_version_str##bison*(GNU Bison)} 2> /dev/null`
    echo "bison version: ${bison_version}"
    vercomp ${bison_version} "3.0.4"
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ "$op" = "<" ]]; then
	bison_version_invalid="1"
    fi
fi

if [[ "$bison_missing" ]] || [[ "$bison_version_invalid" ]]; then
    cd /tmp/
    wget https://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz
    tar -xvf bison-3.0.4.tar.gz
    cd bison-3.0.4
    ./configure
    make
    make install
fi

libmicrohttpd_installed=`find / -name libmicrohttpd 2> /dev/null`
if [[ -z "$libmicrohttpd_installed" ]]; then
    cd /tmp/
    wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.44.tar.gz
    tar -xvf libmicrohttpd-0.9.44.tar.gz
    cd libmicrohttpd-0.9.44
    ./configure
    make install
fi

# Install libxml with brew on Mac OS Yosemite 10.10.5
brew install libxml2
brew link libxml2 --force
export C_INCLUDE_PATH=/usr/local/Cellar/libxml2/2.9.2/include/libxml2:$C_INCLUDE_PATH

mkdir -p ~/Dev
