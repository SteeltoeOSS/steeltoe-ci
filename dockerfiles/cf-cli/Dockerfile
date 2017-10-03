#FROM alpine:latest
#
#RUN   apk update \
# &&   apk add ca-certificates pwgen bash curl jq vim \
# &&   update-ca-certificates \
# &&   rm -r /var/cache/
#
#RUN curl -L 'https://cli.run.pivotal.io/stable?release=linux64-binary&source=github' | tar -zx -C /usr/local/bin/
#
## Use Concourse Credentials Filter
## RUN curl -L 'https://github.com/pivotal-cf-experimental/concourse-filter/releases/download/v0.0.1/concourse-filter' -o /usr/local/bin/concourse-filter  && chmod +x /usr/local/bin/concourse-filter
## RUN mkdir -p /etc/profile.d/
## COPY filter.sh /etc/profile.d/
## RUN chmod 755 /etc/profile.d/filter.sh
## ENV BASH_ENV /etc/profile.d/filter.sh
