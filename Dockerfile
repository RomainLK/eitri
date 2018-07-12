FROM alpine:3.8

LABEL maintainer=romain@homeloop.fr 

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN apk update && apk add python3 python3-dev nodejs npm zip bash libpng libpng-dev gcc g++ make autoconf automake libtool nasm  git curl grep sed unzip
RUN python3 -m ensurepip
RUN pip3 install --upgrade pip
RUN pip3 install awscli
RUN npm install -g npm

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u171
ENV JAVA_ALPINE_VERSION 8.171.11-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/docker-library/openjdk/issues


ENV SONAR_SCANNER_VERSION 2.8
ENV SONAR_SCANNER_HOME /home/sonar-scanner-${SONAR_SCANNER_VERSION}
ENV SONAR_SCANNER_PACKAGE sonar-scanner-${SONAR_SCANNER_VERSION}.zip
ENV SONAR_RUNNER_HOME ${SONAR_SCANNER_HOME}
ENV PATH $PATH:${SONAR_SCANNER_HOME}/bin

ENV WORKDIR /home/workspace
ENV SONAR_RUNNER_HOME=${WORKDIR}/sonar-scanner-3.2.0.1227-linux

WORKDIR /home/workspace


RUN curl --insecure -o ./sonarscanner.zip -L https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
RUN unzip sonarscanner.zip
RUN rm sonarscanner.zip

RUN addgroup sonar && \
  useradd -s /usr/sbin/nologin -d ${SONAR_RUNNER_HOME} -g sonar sonar && \
  chown -R sonar:sonar ${SONAR_RUNNER_HOME} && \
  chown -R sonar:sonar ${WORKDIR}

ENV PATH $PATH:${SONAR_RUNNER_HOME}/bin

USER sonar

ENTRYPOINT []