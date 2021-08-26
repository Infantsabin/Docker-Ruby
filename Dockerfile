FROM ruby:3.0.1-alpine

ENV RACK_ENV=development

RUN apk update

RUN apk add make gcc libpq postgresql postgresql-dev musl-dev  sqlite sqlite-dev libxslt-dev libxml2-dev zlib sqlite-libs libpq openjdk8 curl git

# * to be able to run commands as another user
RUN apk add --no-cache su-exec

RUN mkdir -p /app
WORKDIR /app

RUN mkdir -p /postgres/data

ENV PGHOST=localhost
ENV PGDB=yashoda_2020
ENV PGPORT=5432
ENV PGUSER=dbuser
ENV PGPASS=dbpass@123
# ENV PATH="/opt/Sencha/Cmd:${PATH}"
# ENV UID=12345
# ENV GID=23456

ADD postgresql.conf /postgres/data/postgresql.conf
ADD pg_hba.conf /postgres/data/pg_hba.conf

ADD startup.sh /app/startup.sh

EXPOSE $PGPORT

# * Ruby Gem Install
# ADD Gemfile /app/Gemfile
ADD . /app
RUN gem install bundler
RUN bundle install
RUN bundle update
EXPOSE 9270

ENTRYPOINT [ "./startup.sh" ]
