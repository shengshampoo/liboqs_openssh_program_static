
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE

# liboqs
cd $WORKSPACE
git clone https://github.com/open-quantum-safe/liboqs
cd liboqs
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DOQS_BUILD_ONLY_LIB=ON -DOQS_ENABLE_KEM_HQC=ON ..
ninja
ninja install

# openssh
cd $WORKSPACE
git clone -b OQS-v9 https://github.com/open-quantum-safe/openssh.git
cd openssh
autoreconf -i
LDFLAGS="-static -no-pie -s" ./configure --prefix=/usr/local/liboqs_opensshmm --sysconfdir=/usr/local/liboqs_opensshmm/etc/ssh \
 --without-pam --with-privsep-path=/usr/local/liboqs_opensshmm/lib/sshd/ --with-pid-dir=/usr/local/liboqs_opensshmm/run \
 --with-mantype=man --with-liboqs-dir=/usr
make
make install


cd /usr/local
tar vcJf ./liboqs_opensshmm.tar.xz liboqs_opensshmm

mv ./liboqs_opensshmm.tar.xz /work/artifact/
