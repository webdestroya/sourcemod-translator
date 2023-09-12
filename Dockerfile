FROM ruby:1.9.3

WORKDIR /var/app

ENV RAILS_ENV=production \
    RACK_ENV=production \
    PORT=5000 \
    NODE_VERSION=4.2.6


RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"


# bundler is being stupid, and fails to install this. but if it's installed prior, it works
# no idea, but whatever
RUN gem install nokogiri -v 1.5.6

COPY Gemfile Gemfile.lock /var/app/

RUN bundle install --without development:test --system

COPY . /var/app

RUN bundle exec rake assets:precompile
