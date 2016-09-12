FROM microsoft/dotnet:latest

RUN curl -L 'https://cli.run.pivotal.io/stable?release=linux64-binary&source=github' | tar -zx -C /usr/local/bin/

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
 && echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/4.4.2.11 main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
 && apt-get update \
 && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
 && (apt-get install --fix-missing -y mono-devel vim nodejs || apt-get install --fix-missing -y mono-devel vim nodejs) \
 && npm install -g bower \
 && npm install -g gulp \
 && rm -rf /var/lib/apt/lists/*

# Fix https://github.com/npm/npm/issues/9863
RUN cd $(npm root -g)/npm \
 && npm install fs-extra \
 && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js
