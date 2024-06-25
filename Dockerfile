# syntax = docker/dockerfile:1

### 1. BASE
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-slim AS base
ENV RUBY_VERSION=${RUBY_VERSION}

# Rails app lives here
WORKDIR /rails

### 2. DEPENDENCIES
FROM base AS dependencies

# Install Homebrew dependencies (https://docs.brew.sh/Homebrew-on-Linux#requirements)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential procps curl file git default-libmysqlclient-dev

# Install Homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew binary directory to PATH
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Install app dependencies
COPY Brewfile Brewfile.lock.json ./
RUN brew bundle

### 3. GEMS
FROM dependencies AS gems

# Install Ruby dependencies (gems)
COPY Gemfile Gemfile.lock .ruby-version ./
ARG BUNDLE_DEPLOYMENT
ENV BUNDLE_DEPLOYMENT=${BUNDLE_DEPLOYMENT}
ARG BUNDLE_WITHOUT
ENV BUNDLE_WITHOUT=${BUNDLE_WITHOUT}
RUN bundle install --jobs $(nproc) --retry 3

### 4. BUILD
FROM gems AS build

# Copy application code
COPY . .

# Precompile bootsnap code and assets for faster boot times
RUN bundle exec bootsnap precompile --gemfile
RUN bundle exec bootsnap precompile

# Own only the app files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails .
USER rails:rails

# Set entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

RUN chmod -R +x bin

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
