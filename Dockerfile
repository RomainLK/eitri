FROM alpine:3.8

LABEL maintainer=romain@homeloop.fr 

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG=C.UTF-8

RUN apk update && apk add python2 python2-dev nodejs npm zip bash libpng libpng-dev gcc g++ make autoconf automake libtool nasm  git curl grep sed unzip
RUN python3 -m ensurepip
RUN pip3 install --upgrade pip
RUN pip3 install awscli
RUN npm install -g npm@6.2.0


WORKDIR /root

CMD ["/bin/bash"]