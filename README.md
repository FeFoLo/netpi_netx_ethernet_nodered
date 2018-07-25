## Ethernet across Industrial Ethernet ports with Node Red extension

Made for [netPI RTE 3](https://www.netiot.com/netpi/), the Open Edge Connectivity Ecosystem with Industrial Ethernet support

Project is based on Hilscher image for Ethernet across Industrial Ethernet ports: 

https://github.com/Hilscher/netPI-netx-ethernet-lan


#### Getting started

##### On netPI

STEP 1. Open netPI's landing page under `https://<netpi's ip address>`.

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under **Containers > Add Container**

* **Image**: `flolo/netpi_netx_ethernet_nodered`

* **Volume**: first create Volume then map it `container: /data --> volume: choose created Volume`

* **Restart policy"** : `always`

* **Port mapping**: `Host "1880" (any unused one) -> Container "1880"`

* **Env > add environment variable** : `"MODBUS_TCP_IP" -> IP address of your netPis modbus interface` 
+ **Env > add environment variable** : `"FLOW_NAME" -> Name under which flows are saved, if flows are already saved in Volume load them with thier name` 

* **Runtime > Privileged mode** : `On`

* **Runtime > Devices > add device**: `Host "/dev/spidev0.0" -> Container "/dev/spidev0.0"`

* **Runtime > Devices > add device**: `Host "/dev/net/tun" -> Container "/dev/net/tun"`

STEP 4. Press the button **Actions > Start container**

Pulling the image from Docker Hub may take up to 5 minutes.
