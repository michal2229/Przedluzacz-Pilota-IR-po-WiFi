# WiFi based RTV IR remote range extender

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/19.png)

The aim for this project was to design and develop a device which can be used to extend range of IR communication between RTV remote and RTV device using WiFi. It was latter extended to provide the functionality of controlling RTV devices with a PC or smartphone connected trough WiFi to the device (a web application is presented on the screen). 

The device consists of two cooperating parts in client-server architecture:

1. client part that receives IR code from RTV remote (with IR receiver) and sends it trough WiFi (with ESP8266) to another part,
1. server part that receives code trough WiFi (with ESP8266) and sends it trough IR (with IR LED + amplifier) to RTV device.

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/01.png)

Each part consists of IR element (LED or receiver with demodulation IC), AVR ATmega 328P uC programmed using Arduino libraries and an ESP8266 WiFi module running NodeMCU firmware.

PC/smartphone can also be a client and connect to a server part. 

ESP8266 module can act as an access point and a client at the same time, so there is an option to connect the server part to router and control the device from PC/smartphone connected to the same LAN network - configurable in webapp. 

To decode and encode IR codes I used IRremote library. 

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/20.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/21.png)

### [Proof of concept device](https://github.com/michal2229/Atmega-IR-2.4GHz-nRF24L01) (not ESP8266 yet, it is NRF24L012+):

![proof of concept device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2014-10-27-637%20%E2%80%94%20opisane.jpg)

### Arduino code for client and server IR uC of [proof of concept device](https://github.com/michal2229/Atmega-IR-2.4GHz-nRF24L01):

![code in arduino](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2014-10-27-635.jpg)

### Helper device (displays received IR codes on LCD):

![helper device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2014-10-26-632.jpg)

### Result device:

![result device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2015-02-17-211.jpg)

![result device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2015-02-17-212.jpg)

![result device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2015-02-17-214.jpg)

### Development:

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/02.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/03.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/04.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/05.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/06.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/07.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/08.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/09.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/10.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/11.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/12.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/13.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/22.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/14.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/15.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/16.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/18.png)

![device development](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/17.png)
