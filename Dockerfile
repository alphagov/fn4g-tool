FROM ruby:2.6.0

ENV RACK_ENV development
ENV DB_USER postgres
ENV DB_PASS root
ENV DB_HOST db

WORKDIR /usr/src/app

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update && \
  apt-get install -y apt-transport-https nodejs libuv1 && \
  curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.9.4 && \
  rm -rf /var/lib/apt/lists/*
ENV PATH "$PATH:/root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin"

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install --jobs 20 --retry 5

COPY . .

RUN ASSET_PRECOMPILATION_ONLY=true RAILS_ENV=production bundle exec rails assets:precompile
RUN cp -R /usr/src/app/node_modules /usr/src/.node_modules

CMD ["bundle", "exec", "rails", "server"]
