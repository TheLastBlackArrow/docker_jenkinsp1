#!/bin/bash
mkdir -p /opt/java
cd /opt/java || exit
javaZuluName="zulu11.60.19-ca-jdk11.0.17-linux_aarch32hf"
curl -fsSL "https://cdn.azul.com/zulu-embedded/bin/${javaZuluName}.tar.gz" -o $javaZuluName.tar.gz
tar -xzvf $javaZuluName.tar.gz
rm $javaZuluName.tar.gz
mv $javaZuluName openjdk
update-alternatives --install /usr/bin/java java /opt/java/openjdk/bin/java 1
update-alternatives --install /usr/bin/javac javac /opt/java/openjdk/bin/javac 1