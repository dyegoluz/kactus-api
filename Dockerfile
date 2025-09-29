ARG RUBY_VERSION=3.2.2

FROM ruby:$RUBY_VERSION-slim-bookworm

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

# Copia só Gemfile e lock primeiro (cache de dependências)
COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle config set --global without 'development test' && \
    bundle config set --global path 'vendor/bundle' && \
    bundle config set --global disable_install_doc true && \
    bundle config set force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copia o restante do projeto
COPY . .

# Precompilar assets (se houver)
# RUN bundle exec rake assets:precompile

# Porta padrão do Dokku
EXPOSE 5000

# Não definimos CMD — Dokku vai usar o Procfile
