FROM ruby:2.4.2

RUN mkdir -p /var/app
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN apt-get install -qq -y libcurl3-dev libpq-dev wkhtmltopdf gnupg cron
RUN apt-get install -qq -y netcat postgresql-client-9.6
RUN apt-get install -y --force-yes libpq-dev

RUN echo "gem: -—no-ri -—no-rdoc" > /etc/gemrc

WORKDIR /var/app
COPY Gemfile /var/app/Gemfile
COPY Gemfile.lock /var/app/Gemfile.lock

RUN bundle install --without development test
COPY . /var/app

RUN mkdir -p log

RUN rm -f tmp/pids/server.pid

RUN bundle check || bundle install
