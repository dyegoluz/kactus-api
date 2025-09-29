ARG RUBY_VERSION=3.2.2

# Usamos a imagem base com 'bookworm'
FROM ruby:$RUBY_VERSION-slim-bookworm

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8

# Adiciona a variável de ambiente para o Bundler que pode ajudar a resolver problemas
# de arquitetura em diferentes ambientes.
ENV BUNDLE_FORCE_RUBY_PLATFORM=true

# Workaround para o problema de GPG (ajuda a evitar problemas com chaves ausentes)
# Cria um arquivo vazio no local esperado, às vezes resolve o problema de sub-processo
RUN mkdir -p /etc/apt/keyrings && touch /etc/apt/keyrings/debian-archive-keyring.gpg

# Lista de dependências do sistema
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # Compilação e ferramentas gerais
    ca-certificates \
    build-essential \
    curl \
    git \
    cmake \
    gnupg2 \
    pkg-config \
    wget \
    less \
    # Dependências para libs/gems
    imagemagick \
    ffmpeg \
    ffmpegthumbnailer \
    libxml2-dev \
    libxslt1-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    openssl \
    libgssapi-krb5-2 \
    libpq5 \
    liblzma5 \
    # nodejs (para Asset Pipeline)
    nodejs \
    # Outros que você tinha
    manpages-dev \
    libgit2-dev \
    libpam0g-dev \
    libedit-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
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