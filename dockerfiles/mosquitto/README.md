#Eclipse Mosquitto Docker Image for ARMv7 32-bit or arm32v7 platform.

##Mount Points

Three mount points have been created in the image to be used for configuration, persistent storage and logs.
```
/mosquitto/config
/mosquitto/data
/mosquitto/log
```


##Configuration

When running the image, the default configuration values are used. 
To use a custom configuration file, mount a **local** configuration file to `/mosquitto/config/mosquitto.conf`
```
docker run -it -p 1883:1883 -p 9001:9001 -v <path-to-configuration-file>:/mosquitto/config/mosquitto.conf vproke/rpi-mosqitto
```

Configuration can be changed to:

* persist data to `/mosquitto/data` 
* log to `/mosquitto/log/mosquitto.log`

i.e. add the following to `mosquitto.conf`:
```
persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log
```

**Note**: If a volume is used, the data will persist between containers.

##Build
Build the image:
```
docker build -t vproke/rpi-mosqitto .
```

##Run
Run a container using the new image:
```
docker run -it -p 1883:1883 -p 9001:9001 -v <path-to-configuration-file>:/mosquitto/config/mosquitto.conf -v /mosquitto/data -v /mosquitto/log vproke/rpi-mosqitto
```
:boom: if the mosquitto configuration (mosquitto.conf) was modified
to use non-default ports, the docker run command will need to be updated
to expose the ports that have been configured.

## Credits
Build Dockerfile base on original from https://github.com/eclipse/mosquitto/tree/master/docker git repository.
and arm version from https://github.com/somsakc/docker-mosquitto
