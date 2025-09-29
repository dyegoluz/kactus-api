FROM ruby:3.3

# Instala dependências básicas
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  imagemagick \
  git \
  curl \
  gnupg \
  && rm -rf /var/lib/apt/lists/*

# Instala Node.js (LTS) e Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && corepack enable \
  && corepack prepare yarn@stable --activate

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.6.8
RUN bundle install --jobs 4 --retry 3

COPY . .

# Precompilar assets se precisar
# RUN bundle exec rake assets:precompile

EXPOSE 5000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
