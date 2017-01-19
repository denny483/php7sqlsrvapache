FROM ubuntu:16.04
MAINTAINER denny483 denny483@gmail.com

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    software-properties-common \
    && apt-get update \
    && add-apt-repository ppa:ondrej/php \
    && rm -rf /var/lib/apt/lists/* 

RUN apt-get update && apt-get install -y  --allow-unauthenticated \
    apache2 \
    libapache2-mod-php7.0 \
    mcrypt \
    php-pear \  
    php7.0 \
    php7.0-dev \ 
    php7.0-mbstring \ 
    php7.0-mcrypt \ 
    php7.0-xml \   
    && rm -rf /var/lib/apt/lists/*

RUN curl https://packages.microsoft.com/keys/microsoft.asc -k | apt-key add -  
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list -k > /etc/apt/sources.list.d/mssql-release.list 
RUN echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/mssql-ubuntu-xenial-release/ xenial main" > /etc/apt/sources.list.d/mssqlpreview.list

RUN apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y \
    msodbcsql \
    unixodbc-dev-utf16 \
    && rm -rf /var/lib/apt/lists/*

RUN pecl config-set php_ini /etc/php/7.0/apache2/php.ini \
    && pecl install sqlsrv pdo_sqlsrv \
    &&  echo "extension=/usr/lib/php/20151012/sqlsrv.so" >> /etc/php/7.0/apache2/php.ini \
    && 	echo "extension=/usr/lib/php/20151012/pdo_sqlsrv.so" >> /etc/php/7.0/apache2/php.ini \
    && 	echo "extension=/usr/lib/php/20151012/sqlsrv.so" >> /etc/php/7.0/cli/php.ini \
    && 	echo "extension=/usr/lib/php/20151012/pdo_sqlsrv.so" >> /etc/php/7.0/cli/php.ini \
    &&  echo "default_charset = \"\";" >> /etc/php/7.0/cli/php.ini \
    &&  echo "default_charset = \"\";" >> /etc/php/7.0/apache2/php.ini \
    &&  echo "mssql.charset = \"\";" >> /etc/php/7.0/cli/php.ini \
    &&  echo "mssql.charset = \"\";" >> /etc/php/7.0/apache2/php.ini 
RUN a2enmod php7.0 
RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen    
WORKDIR /var/www/html
VOLUME /var/www/html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80
