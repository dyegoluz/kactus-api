# Use a suitable Ruby base image
FROM ruby:3.2.2-slim-bullseye

# Install necessary system dependencies
RUN apt-get update -qq && apt-get install -yq \
    build-essential \
    nodejs \
    npm \
    postgresql-client \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock to leverage Docker's layer caching
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install --jobs 4 --retry 3 --without development test

# Copy the rest of the application code
COPY . .

# Precompile assets (if applicable for your Rails app)
# This step can be conditional based on your Rails environment
# For Dokku, it's typically done during the build phase
# RUN bundle exec rails assets:precompile

# Expose the port your Rails application will listen on
# Dokku defaults to port 5000 if no port is explicitly exposed.
EXPOSE 5000

# Define the command to run the Rails server
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "5000"]