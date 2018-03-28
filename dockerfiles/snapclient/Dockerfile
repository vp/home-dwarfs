# docker run --rm 
#            --name snapclient 
#            --device=/dev/snd 
#            stilllman/docker-snapclient

FROM resin/rpi-raspbian:stretch
RUN  apt-get update \
  && apt-get install wget -y \
  && apt-get install libasound2-dev libvorbisidec-dev libvorbis-dev libflac-dev alsa-utils libavahi-client-dev avahi-daemon \
  && rm -rf /var/lib/apt/lists/*
ENV  snapcast_version 0.12.0
RUN  wget https://github.com/badaix/snapcast/releases/download/v${snapcast_version}/snapclient_${snapcast_version}_armhf.deb
RUN  apt-get update \
  && apt-get install libatomic1 -y
RUN  dpkg -i snapclient_${snapcast_version}_armhf.deb \
  ;  apt-get update \
  && apt-get -f install -y \
  && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["snapclient"]
CMD ["-h", "snapserver"]
