ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-alpine

ARG BUNDLER_VERSION=2.6.8

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    LANG=C.UTF-8 \
    GEM_HOME=/bundle \
    BUNDLE_PATH=/bundle \
    BUNDLE_APP_CONFIG=/bundle \
    BUNDLE_BIN=/bundle/bin \
    PATH=/app/bin:/bundle/bin:$PATH

# Dependências do sistema (ajuste conforme suas gems precisam)
RUN apk add --no-cache \
    build-base \
    bash \
    git \
    nodejs \
    yarn \
    imagemagick \
    ffmpeg \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    curl \
    tzdata \
    less \
    gcompat \
    libc6-compat

WORKDIR /app

# Cria diretório para bundler e dá permissão
RUN mkdir -p /bundle && chmod 777 /bundle

# Copia Gemfile para cache
COPY Gemfile Gemfile.lock ./

# Instala bundler na versão correta
RUN gem install bundler -v $BUNDLER_VERSION && \
    bundle config set without 'development test' && \
    bundle config set force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copia restante do app
COPY . .

# Precompile assets (se necessário)
# RUN bundle exec rake assets:precompile

EXPOSE 5000