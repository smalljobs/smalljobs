FROM ubuntu:18.04 AS smalljobs_dev
RUN apt-get update
RUN apt-get install -y curl wget gnupg
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN bash -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev openssl libssl-dev libyaml-dev libreadline-dev \
  libxml2-dev libxslt1-dev sudo vim mc curl patch bzip2 gawk g++ gcc make patch autoconf libgdbm-dev libncurses5-dev \
  automake libtool bison pkg-config libffi-dev libgmp-dev imagemagick postgresql-server-dev-10 postgresql-client-10 openssh-server \
  openssh-client net-tools nodejs git locales libmagickwand-dev imagemagick libmagickcore-dev libmagickwand-dev libmagick++-dev \
  webp libwebp-dev redis-server nodejs yarn \
  xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable \
  xfonts-cyrillic x11-apps clang libdbus-1-dev libgtk2.0-dev \
  libnotify-dev libgnome-keyring-dev libgconf2-dev libasound2-dev \
  libcap-dev libcups2-dev libxtst-dev libxss1 \
  libnss3-dev gcc-multilib g++-multilib google-chrome-stable firefox

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

RUN useradd -ms /bin/bash hosting &&  echo hosting:passwordhosting | chpasswd –crypt-method=SHA512  && adduser hosting sudo

USER hosting
WORKDIR /home/hosting
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /home/hosting/workspace
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
RUN echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> .bashrc
RUN  $HOME/.rvm/bin/rvm install 2.3.7 --autolibs=read-only
ENV PATH  = "$HOME/.rvm/bin:$HOME/.rvm/rubies/ruby-2.3.7:${PATH}"
RUN  /bin/bash -l -c "rvm use --default 2.3.7"
RUN  /bin/bash -l -c "rvm use 2.3.7 && gem install bundler -v 1.11.2 && gem install sprockets -v 3.7.2 && gem install rails -v 5.0.3"
RUN  /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' >  $HOME/.gemrc "

RUN echo 'alias smalljobs="cd /home/hosting/workspace/smalljobs"' >> ~/.bash_profile
RUN echo 'alias smalljobs_s="smalljobs && foreman start"' >> ~/.bash_profile
RUN echo 'smalljobs' >> ~/.bash_profile

RUN echo 'if service ssh status | grep -o "not running"' >> ~/.bash_profile
RUN echo 'then' >> ~/.bash_profile
RUN echo '  echo "passwordhosting" | sudo -S service ssh start' >> ~/.bash_profile
RUN echo 'fi' >> ~/.bash_profile

RUN echo "if [ -f /tmp/self_destruct_script.sh ]; then" >> ~/.bash_profile
RUN echo "    bash /tmp/self_destruct_script.sh" >> ~/.bash_profile
RUN echo "fi" >> ~/.bash_profile

COPY self_destruct_script.sh /tmp/self_destruct_script.sh

COPY self_destruct_script.sh /tmp/self_destruct_script.sh
COPY postgres_script.sh /tmp/postgres_script.sh

USER root
RUN chmod 777 /tmp/postgres_script.sh
RUN chmod 777 /tmp/self_destruct_script.sh
RUN chown hosting /tmp/postgres_script.sh
RUN chown hosting /tmp/self_destruct_script.sh
USER hosting
