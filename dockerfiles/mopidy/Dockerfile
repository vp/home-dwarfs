# Run with
#  docker run --rm --name mopidy 
#             -p 6680:6680 -p 6600:6600
#             -v /tmp/snapcast:/tmp 
#             vproke/rpi-mopidy --snapcast


FROM resin/rpi-raspbian:stretch
RUN apt-get update \
 && apt-get install -y wget \
 && wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add - \
 && wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list \
 && apt-get update \
 && apt-get install -y \
    mopidy \
    mopidy-tunein \
    python-pip \
    python-setuptools \
    python-wheel \
 && pip install \
    Mopidy-Moped \
    Mopidy-YouTube \
    Mopidy-Iris \
    Mopidy-Local-SQLite

COPY mopidy.conf /root/.config/mopidy/mopidy.conf.default
COPY mopidy.sh /usr/local/bin/mopidy.sh

EXPOSE 6600 6680
ENTRYPOINT ["/usr/local/bin/mopidy.sh"]
