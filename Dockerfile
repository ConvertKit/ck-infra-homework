FROM ruby:2.5
RUN apt-get update -qq \
      && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
      && apt-get install -y build-essential default-libmysqlclient-dev nodejs \
      && npm install yarn -g
# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT
# Set working directory
WORKDIR $RAILS_ROOT
# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
run bundle install --jobs 20 --retry 5 --without development test
# Adding project files
COPY . .
EXPOSE 3000
run bundle exec rake assets:precompile
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
