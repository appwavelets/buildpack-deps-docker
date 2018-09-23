FROM debian:stretch-slim
ENV HOME /root

RUN apt-get update && apt-get install -y \
  rubygems \
  gnupg \
  gnupg-agent \
  dpkg-sig \
  git \
  libxml2 \
  libxml2-dev \
  libxslt-dev \
  zlib1g-dev \
  rpm \
  python-deltarpm \
  yum \
  python-boto \
  python-pexpect \
  createrepo

RUN gem install bundler

WORKDIR /opt
RUN git clone https://github.com/krobertson/deb-s3.git

WORKDIR /opt/deb-s3
RUN bundle install

COPY docker-entrypoint.sh /usr/local/bin/
COPY rpmmacros /root/.rpmmacros
COPY rpm-s3 /usr/bin
COPY createrepo-patch/__init__.py /usr/share/pyshared/createrepo/__init__.py

RUN mkdir -p /rpm/empty-repo && /usr/bin/createrepo /rpm/empty-repo

ENV PATH="/opt/deb-s3/bin:${PATH}"

WORKDIR /root

ENTRYPOINT ["docker-entrypoint.sh"]
