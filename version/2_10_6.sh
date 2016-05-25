#!/bin/bash -e

# Install Scala 2.10.6
echo "================= Install Scala 2.10.6 ==================="
sudo wget http://downloads.typesafe.com/scala/2.10.6/scala-2.10.6.tgz
sudo tar xzf scala-2.10.6.tgz -C /usr/local && rm -f scala-2.10.6.tgz
echo 'export SCALA_HOME=/usr/local/scala-2.10.6' >> $HOME/.bashrc
echo 'export PATH=$PATH:$SCALA_HOME/bin' >> $HOME/.bashrc
