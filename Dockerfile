FROM ruby:2.5.3-alpine

# Env
ENV INSTALL_PATH /app
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV USER docker

RUN addgroup -g 2000 $USER && \
    adduser -D -h $INSTALL_PATH -u 1000 -G $USER $USER

WORKDIR $INSTALL_PATH

# Bundle install
COPY Gemfile Gemfile.lock ./
ARG BUILD_PACKAGES="build-base"
RUN apk add --no-cache --update $BUILD_PACKAGES \
  && gem install bundler -v '1.17.1' \
  && bundle config --local github.https true \
  && bundle install --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf $BUNDLE_PATH/cache \
  && apk del $BUILD_PACKAGES \
&& chown -R docker:docker $BUNDLE_PATH

COPY --chown=docker:docker . .

USER docker
EXPOSE 9394

CMD ["bundle", "exec", "prometheus_exporter"]
