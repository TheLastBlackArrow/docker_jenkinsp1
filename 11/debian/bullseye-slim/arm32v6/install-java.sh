#!/bin/bash
mkdir -p /usr/lib/jvm
cd /usr/lib/jvm || exit
javaZuluName="zulu11.60.19-ca-jdk11.0.17-linux_aarch32hf"
curl -fsSL "https://cdn.azul.com/zulu-embedded/bin/${javaZuluName}.tar.gz" -o $javaZuluName.tar.gz
tar -xzvf $javaZuluName.tar.gz
rm $javaZuluName.tar.gz
update-alternatives --install /usr/bin/java java /usr/lib/jvm/$javaZuluName/bin/java 1
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/$javaZuluName/bin/javac 1