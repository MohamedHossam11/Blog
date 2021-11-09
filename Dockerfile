FROM ruby:2.7.2

ENV BUNDLER_VERSION="2.1.4" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    mariadb-client \
    sudo \
    vim

RUN apt install npm -y

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

COPY . /app

RUN npm install -g yarn && \
    bundle install -j4 && \
    rails webpacker:install && \
    yarn install --check-files

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]