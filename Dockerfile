FROM debian:stable-slim

# Locale stuff
RUN apt-get update && apt-get install locales -y
RUN sed --in-place '/en_US.UTF-8/s/^#//' /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Ruby + Jekyll dependencies
RUN apt-get update && \
    apt-get install \
    ruby-dev build-essential \
    patch zlib1g-dev liblzma-dev \
    libxml2-dev libxslt-dev git  -y
RUN gem install bundler

# Application
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --path vendor/bundle
COPY . .
EXPOSE 4000

ENTRYPOINT ["bundle", "exec", "jekyll", "serve"]
