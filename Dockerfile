
FROM opensuse/tumbleweed:latest
MAINTAINER william@blackhats.net.au

EXPOSE 4000

RUN zypper in -y python2-Pygments gcc gcc-c++ libxml2-devel libxslt-devel \
    ruby2.6-rubygem-bundler git make tar gzip ruby-devel && \
    zypper clean

RUN mkdir -p /root/389wiki
WORKDIR /root/389wiki

ADD ./ /root/389wiki

RUN bundle install

CMD ["jekyll", "serve", "-H", "0.0.0.0"]


