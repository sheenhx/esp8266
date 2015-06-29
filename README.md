# ESP8266/NodeMCU examples for relayr cloud

This repository provides several examples that using NodeMCU/ESP8266 to connect with relayr cloud.

The basic idea is to use UART/1-wire/SPI/I2C interface of ESP8266 to gather data from different sensor modules, and then use mqtt to publish to relayr cloud.

For the convience of our developers, we provide the http server for onboarding process.

![nodemcu](/pic/NodeMCU.jpg)


First time connect
------

Make sure that you have flashed the firmware that provided by NodeMCU.

https://github.com/nodemcu/nodemcu-firmware/releases/

please choos integer firmware.

Then use Lualoader or other tools to connect to NodeMCU.

Upload the scripts
------

There are several important scripts to be uploaded:

1. init.lua
2. relayrob.lua
3. relayrmqtt.lua
4. relayrobbutton.lua
5. obcfg.lua
6. compile-files.lua (execute after upload all lua files, for saving the memory)
7. relayri2c.lua (optional, can replace your on scripts) 

Get Your Prototyping Credentials
------
If you don't have a [relayr developer](https://developer.relayr.io) account, please create one,
first. Once you have an account, you create a sensor prototype simply
by going on your [relayr devices page](https://developer.relayr.io/dashboard/devices) and moving your mouse pointer
on the big plus button in the lower right corner. In the pop-up
menu which then shows up you click on "Add prototype".

On the next page you create a [relayr device prototype](https://developer.relayr.io/dashboard/prototype) by first
entering a name for your device. Clicking on "Add prototype" then 
will show a page with some credentials which you should save as they
are necessary for connecting your sensor, later. These credentials
come as a JSON dictionary like this:
```
    {
      "user":     "565738d3-18ef-431c-b055-debb1a1be13c",
      "password": "431SsprjRXbX",
      "clientId": "TVlc40xjvQxywVd67GhvhPA",
      "topic":    "/v1/565738d3-18ef-431c-b055-debb1a1be13c/"
    } 
```

On boarding the NodeMCU to relayr cloud
------

Press the FLASH button for 2 seconds after powered up

![nodemcuob](/pic/ob.jpg)

And you have to connect the WIFI SSID begins with ESP like ESP_1092983

After that browse to 192.168.4.1

Enter your relayr credentials and WIFI credentials.
![wifi](/pic/wifi.png)



Exampble (publish the touch sensor data received from i2c)
------

The example provides you the scripts about forwarding data to the relayr cloud.
