# syntax=docker/dockerfile:1
FROM ruby:2.5.0

ENV TZ Asia/Tokyo

ARG BUNDLER_VERSION="2.1.4"
ARG RAILS_ROOT=/mysize

RUN set -x \
&&  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&&  echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list \
&&  curl -sL https://deb.nodesource.com/setup_10.x | bash - \
&&  apt-get update -y \
&&  apt-get install -y build-essential libpq-dev nodejs yarn

ENV LANG C.UTF-8


WORKDIR ${RAILS_ROOT}/frontend
COPY ./frontend/package.json ./frontend/yarn.lock .
RUN set -x \
&&  yarn install


WORKDIR ${RAILS_ROOT}
COPY ./Gemfile ./Gemfile.lock .
RUN set -x \
&&  gem install bundler -v ${BUNDLER_VERSION} -N \
&&  unset BUNDLE_APP_CONFIG BUNDLE_PATH BUNDLE_BIN \
&&  bundle config --local build.mysql2 "--with-ldflags=-L/opt/homebrew/opt/openssl@3/lib" \
&&  bundle install --jobs=3 --retry=2

COPY ./ .

RUN set -x \
&& chmod o+x ./entrypoint.sh

CMD ["/bin/bash", "-c", "./entrypoint.sh"]
