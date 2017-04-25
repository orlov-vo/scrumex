FROM marcelocg/phoenix

# install yarn to sources
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update

# install devel packages and python
RUN apt-get install -y build-essential python
# install inotify
RUN apt-get install -y inotify-tools
# install psql
RUN apt-get install -y postgresql-client
# install yarn
RUN apt-get install -y yarn

# install mix and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# configure work directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ADD . /usr/src/app

CMD ["mix", "phoenix.server"]
