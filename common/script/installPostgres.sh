#!/bin/bash

# Install the driver for PostgreSQL
echo "Install the driver for postgreSQL"
cd /tmp || exit
curl -O -s https://jdbc.postgresql.org/download/postgresql-42.2.1.jar
mv postgres* /config/resources
