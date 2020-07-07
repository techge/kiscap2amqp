kiscap2amqp
===========

[![License](https://img.shields.io/github/license/techge/kiscap2amqp)](/LICENSE)
[![Build Status](https://travis-ci.org/techge/kiscap2amqp.svg?branch=master)](https://travis-ci.org/techge/kiscap2amqp)

Capture wireless packets and send them to a RabbitMQ server.

## Idea

[Kismet](https://www.kismetwireless.net/) surely is one of the most famous OSS for capturing WiFi data, detecting attacks and making penetration tests. Furthermore, Kismet provides a pcap-ng stream to handle the captured data in any way you like - besides that you need to build and install the full Kismet stack.

kiscap2amqp uses the Kismet capture framework and thus benefits from Kismets efforts to support as many e.g. WiFi cards as possible etc. without the need to use the whole server setup of Kismet. kiscap2amqp sends the captured packets one by one to a RabbitMQ server.

There are [multiple possible ways for capturing WiFi data](https://github.com/techge/wifi-arsenal#sniffing), but I did not find a solution to continiously process this data as a stream and with multiple sources in a flexible way. Therefore, I hope this may helps others who wants to get some WiFi packets to a RabbitMQ instance and nothing more, [like I did](https://github.com/techge/eewids).

## Building

At first, you need to install the necessary libraries for building kiscap2amqp. This can be done with the following command for Debian-based systems

```
sudo apt update && sudo apt install build-essential libcap-dev libnl-3-dev libnl-genl-3-dev libnm-dev libpcap-dev librabbitmq-dev pkg-config
```

Afterwards you can use

```
./configure
make
```

for building kiscap2amqp. You can also use the provided Dockerfile for building a container and use this container instead, see [usage section below](#docker).

## Usage

### General

```
$ ./capture_linux_wifi/kiscap2amqp_linux_wifi --help

./capture_linux_wifi/kiscap2amqp_linux_wifi is a capture driver that sends packets to a RabbitMQ server. 

Usage: ./capture_linux_wifi/kiscap2amqp_linux_wifi --source [dev] --cap-exchange [exchange] [options]

 --source [source def]       Specify a source capture device 
 --cap-exchange [exch_name]  Specify the exchange the data should be sent to 
 --rabbitmq [host]:[port]    Connect to RabbitMQ server on [host] and [port]; 
                             defaults to localhost:5672 
 --login [user]:[pw]         Credentials for login to RabbitMQ server 
                             defaults to guest:guest
 --disable-retry             Do not attempt to reconnect to a remote server
                             if there is an error; exit immediately
 --daemonize                 Background the capture tool and enter daemon
                             mode.
 --list                      List supported devices detected
```

An example might be

```
# ./capture_linux_wifi/kiscap2amqp_linux_wifi --source wlan0 --capexchange capture-data
```

You currently need root privileges for managing the network devices. You can use the suid bit to prevent this, but this is not explained here yet. 

### Docker

You can use the provided Dockerfile to build `kiscap2amqp` yourself.

```
git clone https://github.com/techge/kiscap2amqp.git
cd kiscap2amqp
docker build -t kiscap2amqp .
```

To use the container you need to give privileged rights as it will need to use your WiFi card. You can do so by using this command:

```
docker run -ti --net=host --privileged kiscap2amqp --source wlp2s0 --rabbitmq localhost:5672 --cap-exchange capture-raw
```

whereas `wlp2s0` defines your WiFi device, `localhost:5672` the host/port and `capture-raw` the exchange of the RabbitMQ server that shall be used.

### Packages

To be continued (=none so far, you need to build yourself or use the `Dockerfile`).

## TODO

* allow setting channel by parameter
* allow dropping of packet types
* enable cutting data part of data frames
* enable use of config file
* logging to RabbitMQ
* accepting commands via RabbitMQ
* building instructions for OpenWRT
* adding more capture types (e.g. bluetooth)

