#!/bin/bash

sudo apt-get clean
sudo mv /var/lib/apt/lists /tmp
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean
sudo apt-get update

# Install sbt
echo "================= Install sbt ==================="
sudo wget https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.11/sbt-launch.jar
sudo mv sbt-launch.jar /usr/local/bin/sbt-launch.jar
sudo echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss6M -XX:+CMSClassUnloadingEnabled"' > /usr/local/bin/sbt
sudo echo 'java $SBT_OPTS -jar `dirname $0`/sbt-launch.jar "$@"' >> /usr/local/bin/sbt
sudo chmod +x /usr/local/bin/sbt
printf 'exit\n' | sbt

for file in /u14sca/version/*;
do
  $file
done

# Install or update Oracle Java8
echo "================= Install Oracle Java8 ==================="
sudo apt-get update && sudo apt-get install oracle-java8-installer -y