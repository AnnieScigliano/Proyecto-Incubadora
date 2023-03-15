# Project-Incubadora

## Notes before you start :raised_back_of_hand:

 add the current user to the dialout group. This will allow us to use the USB directly

```bash
sudo usermod -a -G dialout $USER
```
We also add ourselves to the group temporarily so we don't have to log in to the system again. If we do not, it will be necessary to restart for the changes to take effect.

```bash
newgrp dialout
```

## Firmware with lua support

 clone the repository

```bash
git clone --branch dev-esp32 --depth=1 --shallow-submodules --recurse-submodules https://github.com/nodemcu/nodemcu-firmware.git firmwareESP32 
```
 Once cloned, download the skdconfig file from this [link](https://nube.altermundi.net/s/3arPqaHxs763pmB/download?path=%2F&files=sdkconfig) and save it in 'firmwareESP32' folder then it should be compiled with :

```bash
make
```
## Burn Firmware with ESPTool

__Installation of ESPTool__

```bash
sudo apt install esptool
```


Put the ESP32 in programming mode by holding the IO0 button and pressing the RST button at the same time.

from the 'build' folder run:

```bash
esptool --chip esp32 --port /dev/ttyUSB0 --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 80m --flash_size detect 0x1000 bootloader/bootloader.bin 0x10000 NodeMCU.bin 0x8000 partitions.bin

```

## Load the Lua scripts

To load the scripts we have 3 options:
* [EspLorer](https://github.com/4refr0nt/ESPlorer)
* [nodemcu-uploader](https://pypi.org/project/nodemcu-uploader/)
* [ZeroBrane](https://studio.zerobrane.com/)



## Option 1 (ESPlorer)

 clone the repository:

```bash
git clone https://github.com/4refr0nt/ESPlorer.git
```
after cloning it:

```bash
cd ESPlorer
./mvnw clean package
```
to execute ESPlorer:

```bash
java -jar target/ESPlorer.jar
```

## Option 2 (nodemcu-uploader)

installation:

```bash
sudo pip install nodemcu-uploader
```
once installed, we can upload files using:

```bash
nodemcu-uploader upload init.lua
```

to see the different commands that can be used:
```bash
nodemcu-uploader -h
```

## Option 3 (ZeroBraneStudio)

installation:
```bash
wget https://download.zerobrane.com/ZeroBraneStudioEduPack-1.90-linux.sh
```
After downloading, we give it execution permission with:

```bash
chmod +x ZeroBraneStudioEduPack-1.90-linux.sh
```
after giving it permissions, run the installer:

```bash
./ZeroBraneStudioEduPack-1.90-linux.sh
```

## Useful Links

* [Pad incubadora](https://pad.codigosur.org/AM_incubadora)
* [Sensor information BME280](https://3iinc.xyz/blog/how-to-use-i2c-sensor-bme280-with-esp32cam/)
* [Documentation nodemcu](https://nodemcu.readthedocs.io/en/dev-esp32)
* [Repository with modules Lua](https://github.com/novalabsxyz/api-examples/blob/master/script/bme280/bme280.lua)
* [Sensor information DHT22](https://nodemcu.readthedocs.io/en/dev-esp32/modules/dht/#dhtread2x)
* [Git Tutorials](https://rogerdudler.github.io/git-guide/index.es.html )
* [Files and photos](https://nube.altermundi.net/s/3arPqaHxs763pmB?path=%2F)


## Diagrams BME280 & DHT22


<p align="center" width="100%">
    <img width="100%" src="https://i.postimg.cc/Hn8SWzzd/image.png">
</p>

<p align="center" width="100%">
    <img width="100%" src="https://i.postimg.cc/B67SfSYR/image.png">
</p>

## Controller diagram
<<<<<<< HEAD
=======


<p align="center" width="100%">
    <img width="100%" src="https://postimg.cc/LgYyWB9b/image.png">
</p>

<p align="center" width="100%">
    <img width="100%" src="https://postimg.cc/kBKWGhB5/image.png">
</p>

>>>>>>> playground

<p align="center" width="100%">
    <img width="100%" src="https://i.postimg.cc/9FNbx62y/Screenshot-from-2023-02-27-09-37-52.png">
</p>


<p align="center" width="100%">
    <img width="100%" src="https://i.postimg.cc/L5vrnNr2/photo1675271656.jpg">
</p>

## made with :heart: by:

<p align="center" width="100%">
    <img width="50%" src="https://user-images.githubusercontent.com/104506596/212185278-8443b89f-9731-4246-a4bd-83f83823351f.png">
</p>




