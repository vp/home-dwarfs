ReSpeaker 2-Mics pHAT
---------------------

Product page: https://shop.pimoroni.com/products/respeaker-2-mics-phat

How to: https://github.com/respeaker/seeed-voicecard

Install:

```bash
sudo ./respeaker
```

Check /boot/config.txt for i2s on and i2s-mmap dtoverlay

    dtparam=i2s=on
    dtoverlay=i2s-mmap
    
    
Speaker test

    speaker-test -l5 -c2 -t wav
    
    
Recording test

    arecord -f cd -Dhw:1 | aplay -Dhw:1
    
On RPI Zero where respeaker is only soundcard use hw:0
    
    
Play mp3

    sudo apt-get install -y mpg123
    mpg123 http://ice1.somafm.com/u80s-128-mp3