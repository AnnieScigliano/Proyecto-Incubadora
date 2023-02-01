# Proyecto-Incubadora

## Notas antes de empezar :raised_back_of_hand:

 Agregar el usuario actual al grupo dialout. Esto permitirá usar el USB de manera directa

```bash
sudo usermod -a -G dialout $USER
```
 Tambien nos agregamos al grupo temporariamente para no tener que volver a loguearnos al sistema. Si no lo hacemos
  será necesario reiniciar para que los cambios tengan efecto

```bash
newgrp dialout
```

## Firmware con soporte para Lua
_Pasitos para hacer funcionar el ESP32_ :grinning:

 Clonar el repositorio 

```bash
git clone --branch dev-esp32 --depth=1 --shallow-submodules --recurse-submodules https://github.com/nodemcu/nodemcu-firmware.git firmwareESP32 
```
 Una vez clonado, descargar el archivo skdconfig desde este [enlace](https://nube.altermundi.net/s/3arPqaHxs763pmB/download?path=%2F&files=sdkconfig) y guardarlo en la carpeta 'firmwareESP32' luego se debe compilar con :

```bash
make
```
## Grabar el Firmware con ESPTool 

__Instalacion de ESPTool__

```bash
sudo apt install esptool
```


Poner el ESP32 en el modo programacion sosteniendo el botón IO0 y apretando el botón RST al mismo tiempo

desde la carpeta 'build' ejecutar:

```bash
esptool --chip esp32 --port /dev/ttyUSB0 --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 80m --flash_size detect 0x1000 bootloader/bootloader.bin 0x10000 NodeMCU.bin 0x8000 partitions.bin

```

## Cargar los scripts Lua

Para cargar los scripts tenemos 3 opciones:
* [EspLorer](https://github.com/4refr0nt/ESPlorer)
* [nodemcu-uploader](https://pypi.org/project/nodemcu-uploader/)
* [ZeroBrane](https://studio.zerobrane.com/)



## Opción 1 (ESPlorer)

clonar el repositorio:

```bash
git clone https://github.com/4refr0nt/ESPlorer.git
```
despues de clonarlo:

```bash
cd ESPlorer
./mvnw clean package
```
para ejecutar ESPlorer:

```bash
java -jar target/ESPlorer.jar
```

## Opción 2 (nodemcu-uploader)

Instalación:

```bash
sudo pip install nodemcu-uploader
```
una vez instalado, podemos subir archivos usando:

```bash
nodemcu-uploader upload init.lua
```

para ver los distintos comandos que se pueden utilizar:
```bash
nodemcu-uploader -h
```

## Opcíon 3 (ZeroBraneStudio)

Instalación:
```bash
wget https://download.zerobrane.com/ZeroBraneStudioEduPack-1.90-linux.sh
```
despues de descargar, le damos permiso de ejecución con:

```bash
chmod +x ZeroBraneStudioEduPack-1.90-linux.sh
```
despues de darle permisos, ejecutamos el instalador:

```bash
./ZeroBraneStudioEduPack-1.90-linux.sh
```

## Links Útiles

* [Pad Incubadora](https://pad.codigosur.org/AM_incubadora)
* [Informacion sobre el sensor BME280](https://3iinc.xyz/blog/how-to-use-i2c-sensor-bme280-with-esp32cam/)
* [Documentacion nodemcu](https://nodemcu.readthedocs.io/en/dev-esp32)
* [Repositorio con modulos Lua](https://github.com/novalabsxyz/api-examples/blob/master/script/bme280/bme280.lua)
* [Infomacion sobre el sensor DHT22](https://nodemcu.readthedocs.io/en/dev-esp32/modules/dht/#dhtread2x)
* [Tutoriales de Git](https://rogerdudler.github.io/git-guide/index.es.html )
* [Archivos y fotos](https://nube.altermundi.net/s/3arPqaHxs763pmB?path=%2F)


## Diagramas BME280 y DHT22


<p align="center" width="100%">
    <img width="100%" src="https://i.postimg.cc/Hn8SWzzd/image.png">
</p>

<p align="center" width="100%">
    <img width="100%" src="https://i.postimg.cc/B67SfSYR/image.png">
</p>



## Hecho con :heart: por:

<p align="center" width="100%">
    <img width="50%" src="https://user-images.githubusercontent.com/104506596/212185278-8443b89f-9731-4246-a4bd-83f83823351f.png">
</p>




