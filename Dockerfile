FROM debian:stretch-slim
ENV HOME /root

RUN apt-get update && apt-get install --no-install-recommends -y \
  python-boto \
  gnupg \
  git \
  rubygems \
  rpm \
  yum \
  createrepo \
  python-pexpect

RUN gem install bundler

WORKDIR /opt
RUN git clone https://github.com/krobertson/deb-s3.git

WORKDIR /opt/deb-s3
RUN bundle install && \
    apt-get purge -y --auto-remove rubygems git && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /rpm/empty-repo && \
    /usr/bin/createrepo /rpm/empty-repo

COPY docker-entrypoint.sh /usr/local/bin/
COPY rpmmacros /root/.rpmmacros
COPY rpm-s3 /usr/bin
COPY createrepo-patch/__init__.py /usr/share/pyshared/createrepo/__init__.py

ENV PATH="/opt/deb-s3/bin:${PATH}"

WORKDIR /root

ENTRYPOINT ["docker-entrypoint.sh"]
