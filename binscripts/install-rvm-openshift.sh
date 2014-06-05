#!/usr/bin/env bash

libyaml_package="yaml-0.1.4"
libyaml_url="http://pyyaml.org/download/libyaml/${libyaml_package}.tar.gz"
rvm_installer="https://raw.githubusercontent.com/xiy/rvm-openshift/master/binscripts/rvm-installer"

echo "=== Are we in the data path...?"
if [[ ! ${pwd} == ${OPENSHIFT_DATA_DIR} ]]; then
  cd ${OPENSHIFT_DATA_DIR}
fi

echo "=== Getting ${libyaml_url}..."
wget ${libyaml_url} & 
wait $!
tar zxvf ${libyaml_package}.tar.gz &
wait $!
cd ${libyaml_package}

if [ ! -d "${OPENSHIFT_DATA_DIR}/.rvm/usr" ]; then
  mkdir ${OPENSHIFT_DATA_DIR}/.rvm/usr
fi

echo "=== Building ${libyaml_package}..."
./configure --prefix=${OPENSHIFT_DATA_DIR}/.rvm/usr &
wait $!

make && make install &
wait $!

echo "=== Installing RVM and Ruby 1.9.3..."
curl -sSL ${rvm_installer} | bash -s master --ruby &
wait $!

echo "=== ALL DONE ==="
echo "=== NOTE: You MUST run the 'source $OPENSHIFT_DATA_DIR/.rvm/scripts/rvm' command whenever you wish to use RVM!"
