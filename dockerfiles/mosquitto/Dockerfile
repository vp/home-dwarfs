FROM resin/rpi-raspbian:stretch

RUN apt-get update && \
    apt-get -y install wget

RUN wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
    apt-key add mosquitto-repo.gpg.key && \
    rm -f mosquitto-repo.gpg.key && \
    cd /etc/apt/sources.list.d/ && \
    wget http://repo.mosquitto.org/debian/mosquitto-jessie.list && \
    apt-get update && \
    apt-get -y install mosquitto

RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
	cp /etc/mosquitto/mosquitto.conf /mosquitto.config && \
    chown -R mosquitto:mosquitto /mosquitto

COPY config/mosquitto.conf /mosquitto/config

COPY docker-entrypoint.sh /

RUN chown mosquitto:mosquitto /docker-entrypoint.sh && \
    chmod ug+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]

