FROM jruby

COPY . /src
WORKDIR /src

RUN bundle install
