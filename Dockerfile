FROM ubuntu:20.04
USER root
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-setuptools \
    curl \
    && pip3 install --upgrade pip \
    && apt-get clean
RUN apt-get -y install zip
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN apt install -y --no-install-recommends yarn

RUN pip3 --no-cache-dir install --upgrade awscli
RUN node --version
RUN aws --version
RUN python3 --version

# PhantomJS
ENV PHANTOMJS_VERSION 2.1.1
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
    curl \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Run as non-root user 
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs

USER phantomjs 
EXPOSE 8910 
CMD ["/usr/local/bin/phantomjs"]