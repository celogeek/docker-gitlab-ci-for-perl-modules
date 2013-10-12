FROM findspire/wheezy
MAINTAINER Vincent Bachelier <vincent@weborama.com>

ENV DEBIAN_FRONTEND noninteractive

ADD scripts /
RUN chmod +x /setup.sh && /setup.sh && rm /setup.sh
ENTRYPOINT /bin/su - gitlab_ci_runner -c /build.sh
