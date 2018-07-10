FROM alpine:3.8

MAINTAINER romain@homeloop.fr 

RUN apk update && apk add python3 python3-dev 
RUN python3 -m ensurepip
RUN apk add nodejs npm zip bash libpng libpng-dev gcc g++ make autoconf  \
    automake libtool nasm openjdk8 git curl grep sed unzip postgresql-dev \
    gfortran build-base openblas
RUN pip3 install --upgrade pip
RUN pip3 install awscli
RUN npm install -g npm

WORKDIR /root

RUN curl --insecure -o ./sonarscanner.zip -L https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
RUN unzip sonarscanner.zip
RUN rm sonarscanner.zip

ENV SONAR_RUNNER_HOME=/root/sonar-scanner-3.2.0.1227-linux
ENV PATH $PATH:/root/sonar-scanner-3.2.0.1227-linux/bin

ENTRYPOINT []