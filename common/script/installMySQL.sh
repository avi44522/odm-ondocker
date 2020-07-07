#!/bin/bash

# Install the driver for MySQL
echo "Install the driver for MySQL"
cd /tmp || exit
curl -O -s http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.22/mysql-connector-java-5.1.22.jar
mv mysql* /config/resources
