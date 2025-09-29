ARG RUBY_VERSION=3.2.2

# Usamos a imagem base com 'bookworm'
FROM ruby:$RUBY_VERSION-slim-bookworm

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8

# Adiciona a variável de ambiente para o Bundler que pode ajudar a resolver problemas
# de arquitetura em diferentes ambientes.
ENV BUNDLE_FORCE_RUBY_PLATFORM=true

# Adiciona um workaround para o problema de GPG
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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

# Define o diretório de trabalho
WORKDIR /app

# Copia arquivos essenciais para o cache de camadas do Docker
COPY Gemfile Gemfile.lock ./

# Instalação das gems.
RUN bundle config set --local without 'development test' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3

# Copia o restante do código da aplicação, incluindo o Procfile e o nginx.conf.sigil.
COPY . .

# Expõe a porta 5000, que é o padrão do Dokku.
EXPOSE 5000
