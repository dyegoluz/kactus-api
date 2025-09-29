ARG RUBY_VERSION=3.2.2

FROM ruby:$RUBY_VERSION-bookworm

ARG BUNDLER_VERSION=2.4.10

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_ENV=production
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8
ENV GEM_HOME=/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH=/app/bin:$BUNDLE_BIN:$PATH

# Atualiza chaves GPG do Debian (necessário porque as antigas expiraram)
RUN apt-get update -qq && apt-get install -y --no-install-recommends gnupg ca-certificates curl && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://ftp-master.debian.org/keys/archive-key-12.asc | gpg --dearmor -o /etc/apt/keyrings/debian-archive-keyring.gpg && \
    curl -fsSL https://ftp-master.debian.org/keys/release-12.asc | gpg --dearmor -o /etc/apt/keyrings/debian-release.gpg

# Dependências do sistema
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    curl \
    git \
    cmake \
    gnupg2 \
    pkg-config \
    imagemagick \
    ffmpegthumbnailer \
    manpages-dev \
    libgit2-dev \
    wget \
    ffmpeg \
    less \
    libxml2-dev \
    libgssapi-krb5-2 \
    libpq5 \
    libpam0g-dev \
    libedit-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    openssl \
    liblzma5 \
    libpq-dev \
    nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

WORKDIR /app

# Copia só Gemfile e lock para cache do bundle
COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle config set --global without 'development test' && \
    bundle config set --global path 'vendor/bundle' && \
    bundle config set --global disable_install_doc true && \
    bundle config set force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copia restante do projeto
COPY . .

# Precompilar assets (descomente se usar sprockets/jsbundling/cssbundling)
# RUN bundle exec rake assets:precompile

# Porta usada pelo Dokku
EXPOSE 5000