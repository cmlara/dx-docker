#!/bin/sh
mysql -uroot -p${RDS_MYSQL_ROOT_PASSWORD} \
-e "CREATE DATABASE IF NOT EXISTS ${CMS_SDEP_DB_NAME}; GRANT ALL PRIVILEGES ON ${CMS_SDEP_DB_NAME}.* TO '${CMS_SDEP_DB_USER}' identified by '${CMS_SDEP_DB_PASSWORD}';";
