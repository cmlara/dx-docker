FROM drupal:8.9-apache

RUN apt-get update && apt-get install -y zip unzip

# Add composer
WORKDIR /root
RUN echo "alias composer='php -d allow_url_fopen=On /root/composer.phar'" >> ~/.bashrc
RUN curl -k -O https://getcomposer.org/installer
RUN php -d allow_url_fopen=On installer
WORKDIR /var/www/html

# Add AWS sdk (for s3fs)
RUN php -d allow_url_fopen=On /root/composer.phar require aws/aws-sdk-php

# Add Drush (if needed)
# RUN php -d allow_url_fopen=On /root/composer.phar require drush/drush

# Setup apache config for drupal modules
COPY ./config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./config/proxy.conf /etc/apache2/mods-available/proxy.conf
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load
RUN ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf
RUN ln -s /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled/proxy_http.load
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load
RUN ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf
RUN ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load
RUN ln -s /etc/apache2/mods-available/socache_shmcb.conf /etc/apache2/mods-enabled/socache_shmcb.conf

# Setup default modules
RUN mkdir -p /var/www/html/modules/custom
ADD ./modules/* /var/www/html/modules/custom/

COPY ./config/settings.php /var/www/html/sites/default/settings.php
COPY ./config/services.yml /var/www/html/sites/default/services.yml
RUN chown www-data:www-data ./sites/default/*