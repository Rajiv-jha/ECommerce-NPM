#!/bin/bash

# Start SSH
sudo /etc/init.d/ssh start

# Start MySQL
sudo service mysql start

if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
        export MYSQL_ROOT_PASSWORD="singcontroller";
fi
 
# Configure MySQL
sudo mysqladmin -uroot password $MYSQL_ROOT_PASSWORD
sudo mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "grant all on *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'"

# Restart MySQL
sudo service mysql restart

exit 0
