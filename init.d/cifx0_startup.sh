#!/bin/bash +e
### BEGIN INIT INFO
# description: cifx0 daemon
# processname: cifx0 startup with ip
### END INIT INFO

echo "Start cifx0"
sudo ip link set cifx0 up

