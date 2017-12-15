FROM ruby:2.3.1

RUN mkdir -p $HOME/.config/goohub

RUN echo 'gem: --no-ri --no-rdoc' > $HOME/.gemrc

ARG GOOHUB_VERSION
ENV GOOHUB_VERSION $GOOHUB_VERSION

COPY pkg/goohub-${GOOHUB_VERSION}.gem /tmp
RUN gem install /tmp/goohub-${GOOHUB_VERSION}.gem

ENTRYPOINT [ "goohub" ]
CMD [ "help" ]
