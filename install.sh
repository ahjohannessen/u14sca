#!/bin/bash -e

sudo apt-get clean
sudo mv /var/lib/apt/lists /tmp
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean
sudo apt-get update

echo "================ Installing oracle-java8-installer ================="
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java8-installer
update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-oracle/bin/javac
update-alternatives --set javaws /usr/lib/jvm/java-8-oracle/jre/bin/javaws
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/lib/jvm/java-8-oracle/jre/bin' >> $HOME/.bashrc


echo "================ Installing Letsencrypt certs ================="
KEYSTORE=/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts

wget https://letsencrypt.org/certs/letsencryptauthorityx1.der
wget https://letsencrypt.org/certs/letsencryptauthorityx2.der
wget https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.der
wget https://letsencrypt.org/certs/lets-encrypt-x2-cross-signed.der
wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.der
wget https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.der

keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias isrgrootx1 -file letsencryptauthorityx1.der
keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias isrgrootx2 -file letsencryptauthorityx2.der
keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx1 -file lets-encrypt-x1-cross-signed.der
keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx2 -file lets-encrypt-x2-cross-signed.der
keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx3 -file lets-encrypt-x3-cross-signed.der
keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx4 -file lets-encrypt-x4-cross-signed.der

rm -f letsencryptauthorityx1.der letsencryptauthorityx2.der lets-encrypt-x1-cross-signed.der lets-encrypt-x2-cross-signed.der lets-encrypt-x3-cross-signed.der lets-encrypt-x4-cross-signed.der

# Install sbt
echo "================= Installing sbt ==================="
sudo wget https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.13/sbt-launch.jar
sudo mv sbt-launch.jar /usr/local/bin/sbt-launch.jar
sudo echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss6M -XX:+CMSClassUnloadingEnabled"' > /usr/local/bin/sbt
sudo echo 'java $SBT_OPTS -jar `dirname $0`/sbt-launch.jar "$@"' >> /usr/local/bin/sbt
sudo chmod +x /usr/local/bin/sbt
printf 'exit\n' | sbt

for file in /u14sca/version/*;
do
  ${file}
done

# NodeJS, NPM & JSDOM
NODEJS_VERSION="6.9.1"
NPM_VERSION="4.0.3"
JSDOM_VERSION="9.8.3"
echo "================= Installing nodejs $NODEJS_VERSION, npm $NPM_VERSION & jsdom $JSDOM_VERSION ==================="
apt-get purge nodejs && apt-get autoremove && apt-get autoclean
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
export NVM_DIR="/$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install ${NODEJS_VERSION} && nvm use ${NODEJS_VERSION} && nvm alias default ${NODEJS_VERSION} && npm install -g --save npm@${NPM_VERSION} && npm install -g --save jsdom@${JSDOM_VERSION}