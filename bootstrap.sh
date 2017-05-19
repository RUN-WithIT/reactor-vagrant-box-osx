#!/bin/bash

# Install basic dependencies.
brew install wget cmake emacs
brew install gnu-sed --with-default-names
brew install flex
brew install guile
brew install libmicrohttpd
brew install mono

bison_missing=`command -v bison >/dev/null 2>&1`
if [[ "$bison_missing" ]]; then
    cd /tmp/
    wget https://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz
    tar -xvf bison-3.0.4.tar.gz
    cd bison-3.0.4
    ./configure
    make
    make install
fi

cd /tmp/
wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.44.tar.gz
tar -xvf libmicrohttpd-0.9.44.tar.gz
cd libmicrohttpd-0.9.44
./configure
make install

# Install libxml with brew on Mac OS Yosemite 10.10.5
brew install libxml2
brew link libxml2 --force
export C_INCLUDE_PATH=/usr/local/Cellar/libxml2/2.9.2/include/libxml2:$C_INCLUDE_PATH

mkdir -p ~/Dev
