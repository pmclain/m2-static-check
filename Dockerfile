FROM php:7.2-cli

LABEL MAINTAINER="Patrick McLain <pat@pmclain.com>"

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    software-properties-common \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libsodium-dev \
    libpng-dev \
    libxslt1-dev \
    sudo \
    cron \
    rsyslog \
    git


RUN mkdir -p /usr/share/man/man1 \
  && apt-get install -y default-jre

RUN curl -o allure-2.6.0.tgz -Ls https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.6.0/allure-2.6.0.tgz \
  && tar -zxvf allure-2.6.0.tgz -C /opt/ \
  && ln -s /opt/allure-2.6.0/bin/allure /usr/bin/allure \
  && allure --version

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions

RUN docker-php-ext-install \
  dom \
  gd \
  intl \
  mbstring \
  pdo_mysql \
  xsl \
  zip \
  soap \
  bcmath \
  sodium

ENV COMPOSER_ALLOW_SUPERUSER 1
VOLUME /root/.composer/cache
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# phpcpd has been using ~350MB during execution
# integrity tests were exceeding 500MB
RUN echo "memory_limit = 1G" > /usr/local/etc/php/conf.d/zz-cli.ini

COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
