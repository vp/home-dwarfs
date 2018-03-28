# docker run --rm
#            --name snapserver 
#            -p 1704:1704 -p 1705:1705
#            -v /tmp/snapcast:/tmp
#            stilllman/docker-snapserver


FROM resin/rpi-raspbian:stretch
RUN  apt-get update \
  && apt-get install wget -y \
  && apt-get install libasound2-dev libvorbisidec-dev libvorbis-dev libflac-dev alsa-utils libavahi-client-dev avahi-daemon \
  && rm -rf /var/lib/apt/lists/*
ENV  snapcast_version 0.12.0
RUN  wget https://github.com/badaix/snapcast/releases/download/v${snapcast_version}/snapserver_${snapcast_version}_armhf.deb
RUN  dpkg -i snapserver_${snapcast_version}_armhf.deb \
  ;  apt-get update \
  && apt-get -f install -y \
  && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["snapserver"]
