# Run with
#  docker run --rm --name mopidy 
#             -p 6680:6680 -p 6600:6600 
#             -e SPOTIFY_USERNAME -e SPOTIFY_PASSWORD 
#             -e LASTFM_USERNAME -e LASTFM_PASSWORD
#             -v /tmp/snapcast:/tmp 
#             stilllman/mopidy --snapcast


FROM resin/rpi-raspbian:stretch
RUN  apt-get update
RUN  apt-get install -y \
     wget
RUN  wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
RUN  wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list
RUN  apt-get update \
  && apt-get install -y \
     mopidy \
     mopidy-spotify \
     mopidy-tunein \
     mopidy-scrobbler
RUN  apt-get install -y \
     python-pip \
     python-setuptools
RUN  pip install Mopidy-Moped
RUN  pip install Mopidy-Iris
RUN  pip install Mopidy-Local-SQLite

COPY mopidy.conf /root/.config/mopidy/mopidy.conf
COPY mopidy.sh /usr/local/bin/mopidy.sh

EXPOSE 6600 6680
ENTRYPOINT ["/usr/local/bin/mopidy.sh"]
