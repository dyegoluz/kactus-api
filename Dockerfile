ARG RUBY_VERSION=3.2.2

# Usamos a imagem base com 'bookworm', que é a mais robusta.
FROM ruby:$RUBY_VERSION-slim-bookworm

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8

# Adicionamos a variável de ambiente para o Bundler que pode ajudar a resolver problemas
# de arquitetura em diferentes ambientes.
ENV BUNDLE_FORCE_RUBY_PLATFORM=true

# Instalação das dependências do sistema
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

# Define o diretório de trabalho
WORKDIR /app

# Copia arquivos essenciais para o cache de camadas do Docker
COPY Gemfile Gemfile.lock ./

# Instalação das gems. O Dokku detectará o Procfile automaticamente.
# Usamos `bundle config set` em vez da flag obsoleta `--without`.
RUN bundle config set --local without 'development test' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3

# Copia o restante do código da aplicação, incluindo o Procfile e o nginx.conf.sigil.
COPY . .

# Expõe a porta 5000, que é o padrão do Dokku. O Nginx do Dokku fará o roteamento.
EXPOSE 5000

# O Dokku detecta a instrução de execução a partir do `Procfile`, por isso a
# linha `CMD` não é necessária ou pode ser simplificada.
# Removendo a linha CMD pois o Procfile já definirá o processo `web`.
# A ausência de um `CMD` no Dockerfile faz com que o Dokku procure o `Procfile`
# para determinar o comando de inicialização.

# Para o Nginx, o Dokku extrai o `nginx.conf.sigil` que estiver na raiz
# do diretório de trabalho (`/app` neste caso) e o utiliza para configurar
# o proxy. Não é necessária nenhuma instrução adicional no Dockerfile.
