FROM resin/rpi-raspbian:stretch

RUN apt-get update \
	&& apt-get install -y curl wget build-essential \
	&& apt-get install raspberrypi-kernel-headers raspberrypi-kernel \
	&& apt-get install dkms git i2c-tools \
	&& apt-get install -y alsa-utils

COPY respeaker.sh build.sh
COPY run.sh run.sh

RUN ./build.sh

RUN apt-get update && apt-get install -y alsa-utils
CMD ./run.sh
