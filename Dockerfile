ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-alpine

ARG BUNDLER_VERSION=2.6.8

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/app/vendor/bundle \
    BUNDLE_BIN=/app/vendor/bundle/bin \
    BUNDLE_APP_CONFIG=/app/vendor/bundle

# Dependências do sistema
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

# Copia Gemfile
COPY Gemfile Gemfile.lock ./

# Instala bundler na versão correta e gems
RUN gem install bundler -v $BUNDLER_VERSION && \
    bundle config set without 'development test' && \
    bundle config set force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copia o restante do projeto
COPY . .

# Precompile assets (se necessário)
# RUN bundle exec rake assets:precompile

EXPOSE 5000

# Dokku usará o Procfile
