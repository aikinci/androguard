# A dockerized androguard installation
FROM ubuntu:14.04
MAINTAINER ali@ikinci.info

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y dist-upgrade 
RUN apt-get install -y --no-install-recommends build-essential curl g++ git graphviz ipython libbz2-dev liblzma-dev libmuparser-dev libsnappy-dev libsparsehash-dev mercurial nano python python-beautifulsoup python-dev python-magic python-networkx python-openssl python-pip python-ptrace python-pydot python-pygments python-setuptools python-sklearn python-snappy python-twisted unzip zip zlib1g-dev

RUN pip install simhash elfesteem

WORKDIR /opt/

RUN curl -sO http://www.chilkatsoft.com/download/9.5.0.40/chilkat-9.5.0-python-2.7-x86_64-linux.tar.gz
RUN tar xvfz chilkat-9.5.0-python-2.7-x86_64-linux.tar.gz
RUN mv chilkat-9.5.0-python-2.7-x86_64-linux/_chilkat.so /usr/local/lib/python2.7/dist-packages
RUN mv chilkat-9.5.0-python-2.7-x86_64-linux/chilkat.py /usr/local/lib/python2.7/dist-packages

RUN hg clone https://androguard.googlecode.com/hg/ androguard 
RUN cp -r androguard androguard-build
WORKDIR /opt/androguard-build/
RUN make
RUN sed 's/distribute//g' /opt/androguard/setup.py -i
RUN python setup.py install
RUN cp -r elsim/elsim /usr/lib/python2.7/

WORKDIR /opt/

ADD mercury.tar.gz /opt
RUN cp -r mercury/merc /usr/lib/python2.7/
RUN cp mercury/mercury.apk .

ADD pyfuzzy-0.1.0.tar.gz /opt
RUN cd pyfuzzy-0.1.0/ && python setup.py install

RUN rm -rf /opt/pyfuzzy-0.1.0 /opt/chilkat-9.5.0-python-2.7-x86_64-linux/ /opt/chilkat-9.5.0-python-2.7-x86_64-linux.tar.gz /opt/mercury /opt/androguard-build

WORKDIR /root
ENV HOME /root