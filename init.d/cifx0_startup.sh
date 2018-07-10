#!/bin/bash +e


# code from https://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        oldIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$oldIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

echo "IP Check is running at "`date`
modbus_ip="$MODBUS_TCP_IP"
# code from https://www.cyberciti.biz/faq/linux-unix-howto-check-if-bash-variable-defined-not/
# check if env variable is set
if [[ $modbus_ip && ${modbus_ip-x} ]]
then
 # check if IP address is valid
 if valid_ip $modbus_ip
 then
  echo "Your ip  address: $modbus_ip is valid"
  #check 10 times if cifx0 is up in running
  cifx0_installed=$( ip addr show | grep cifx | awk '{ print $2 }' | head -n 1)
  if [ -n "$cifx0_installed" ]
  then
   cifx0_status=$( ip addr show | grep cifx0 | awk '{ print $9 }' | head -n 1 )
   if [ $cifx0_status == 'DOWN' ]
   then
    sudo ip link set cifx0 up
   fi
   # check if cifx0 is up in running
   for i in `seq 1 10`
   do
    # wait for cifx0 to be booted up
    cifx0_status=$( ip addr show | grep cifx0 | awk '{ print $9 }' | head -n 1 )
    if [ $cifx0_status == "UP" ]
    then
     sudo ip addr add $modbus_ip/24 dev cifx0
     echo "Device cifx0 is up in running"
     break
    else
     echo "Device cifx0 is not up in running"
    fi
    sleep 1.5
   done
   #end for
  else
   echo "cifx0 is not available"
  fi
 else
  echo "bad $modbus_ip"
 fi
else
 echo "No ModbusIP is set"
fi

