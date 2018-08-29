FROM ubuntu:16.04
ENV RUBY_VER="2.4.4"

#Install dependancies for ruby and for puppet/r10k/octocatalog-diff.
RUN apt-get update; apt-get upgrade -y; \
    apt-get install -y curl git patch bzip2 gawk g++ gcc make cmake libc6-dev patch zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev libreadline6-dev libssl-dev

# install RVM, Ruby, and Bundler
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -; \
    curl -sSL https://get.rvm.io | bash -s stable; \
    /bin/bash -l -c "rvm requirements"; \
    /bin/bash -l -c "rvm install $RUBY_VER"; \
    /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"; \
    touch ~/.bashrc; \
    echo 'source /etc/profile.d/rvm.sh' > ~/.bashrc

# make bundler a default gem
RUN echo bundler >> /usr/local/rvm/gemsets/global.gems

# setup some default flags from rvm (auto install, auto gemset create, quiet curl)
RUN echo "rvm_install_on_use_flag=1\nrvm_gemset_create_on_use_flag=1\nrvm_quiet_curl_flag=1" > ~/.rvmrc

# source rvm in every shell
RUN sed -i '3i . /etc/profile.d/rvm.sh\n' ~/.profile

# interactive shell by default so rvm is sourced automatically
ENTRYPOINT /bin/bash -l