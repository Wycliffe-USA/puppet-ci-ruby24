FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl git patch bzip2 gawk g++ gcc make libc6-dev patch zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev libreadline6-dev libssl-dev
#RUN gem install puppet-lint --no-document

# install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    \curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c 'source /etc/profile.d/rvm.sh'

# make bundler a default gem
RUN echo bundler >> /usr/local/rvm/gemsets/global.gems

# setup some default flags from rvm (auto install, auto gemset create, quiet curl)
RUN echo "rvm_install_on_use_flag=1\nrvm_gemset_create_on_use_flag=1\nrvm_quiet_curl_flag=1" > ~/.rvmrc

# source rvm in every shell
RUN sed -i '3i . /etc/profile.d/rvm.sh\n' ~/.profile

# interactive shell by default so rvm is sourced automatically
ENTRYPOINT /bin/bash -l

#Install ruby 2.3
RUN /usr/local/rvm/bin/rvm install 2.3.0
