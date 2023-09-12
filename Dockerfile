FROM ruby:1.9.3

WORKDIR /var/app

ENV RAILS_ENV=production \
    RACK_ENV=production \
    PORT=5000

# bundler is being stupid, and fails to install this. but if it's installed prior, it works
# no idea, but whatever
RUN gem install nokogiri -v 1.5.6

COPY Gemfile Gemfile.lock /var/app/

RUN bundle install --without development:test --deployment

COPY . /var/app

RUN bundle exec rake assets:precompile
