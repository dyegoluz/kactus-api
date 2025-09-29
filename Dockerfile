FROM ruby:3.3

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  imagemagick \
  git \
  && rm -rf /var/lib/apt/lists/*

# Cria diretório do app
WORKDIR /app

# Copia Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Garante Bundler compatível
RUN gem install bundler -v 2.6.8
RUN bundle install --jobs 4 --retry 3

# Copia o resto do projeto
COPY . .

# Precompila assets (se usar sprockets/webpacker/jsbundling/cssbundling)
# RUN bundle exec rake assets:precompile

# Expõe porta padrão do Dokku
EXPOSE 5000

# Comando default para rodar o servidor
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
