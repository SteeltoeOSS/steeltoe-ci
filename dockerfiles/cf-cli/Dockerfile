FROM alpine:latest

RUN   apk update \
 &&   apk add ca-certificates pwgen bash curl jq \
 &&   update-ca-certificates \
 &&   rm -r /var/cache/

RUN curl -L 'https://cli.run.pivotal.io/stable?release=linux64-binary&source=github' | tar -zx -C /usr/local/bin/

