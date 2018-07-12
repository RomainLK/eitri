FROM alpine:3.8

LABEL maintainer=romain@homeloop.fr 

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN apk update && apk add python3 python3-dev 
RUN python3 -m ensurepip
RUN apk add nodejs npm zip bash libpng libpng-dev gcc g++ make autoconf  \
    automake libtool nasm openjdk8 git curl grep sed unzip
RUN pip3 install --upgrade pip
RUN pip3 install awscli
RUN npm install -g npm

WORKDIR /root

RUN curl --insecure -o ./sonarscanner.zip -L https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
RUN unzip sonarscanner.zip
RUN rm sonarscanner.zip

ENV SONAR_RUNNER_HOME=/root/sonar-scanner-3.2.0.1227-linux
ENV PATH $PATH:/root/sonar-scanner-3.2.0.1227-linux/bin

CMD ["/bin/bash"]