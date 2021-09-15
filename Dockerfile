# 1. Pull official base image
FROM ruby:2.7.1

# 2. Install dependencies
RUN apt-get update \
  && apt-get install -y \
    build-essential \
    postgresql postgresql-contrib libpq-dev

# 3. Set work directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# 4. Copy Gemfile
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock

# 5. Install gems
RUN bundle install --jobs 4 --retry 3

# 6. Copy project
COPY . /usr/src/app

# 7. Expose port 3000 to the Docker host, so we can access it from the outside
EXPOSE 3000

# 8. Add a script to be executed every time the container starts.
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "/usr/bin/entrypoint.sh"]

# 9. Start web server.
CMD ["rails", "server", "-b", "0.0.0.0"]
