FROM ruby:latest

RUN curl -L 'https://cli.run.pivotal.io/stable?release=linux64-binary&source=github' | tar -zx -C /usr/local/bin/
RUN gem install mechanize cf-uaac
