FROM 389ds/389ds-website-ruby-27
MAINTAINER awood@redhat.com

USER root
RUN mkdir -p /site && chmod 777 /site
WORKDIR /site

# The gems are installed globally and the copied Gemfiles will be
# hidden when the site source is mounted into /site
COPY ./Gemfile* .
RUN bundle install

USER 1001
# Turn off disk caching; jekyll tries to create a .jekyll-cache directory in the volume
# mount which is doesn't have permission to do
CMD bundle exec jekyll serve -d /tmp --disable-disk-cache --livereload -H 0.0.0.0
