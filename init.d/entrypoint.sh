#!/bin/bash +e
# catch signals as PID 1 in a container

# SIGNAL-handler
term_handler() {

  echo "terminating ssh ..."
  /etc/init.d/ssh stop,
  echo "terminating node red ..."
  /usr/bin/node-red stop,

  exit 143; # 128 + 15 -- SIGTERM
}

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' SIGINT SIGKILL SIGTERM SIGQUIT SIGTSTP SIGSTOP SIGHUP

# run applications in the background
echo "starting ssh ..."
/etc/init.d/ssh start

# create netx "cifx0" ethernet network interface 
/opt/cifx/cifx0daemon

# config cifx0
/etc/init.d/cifx0_startup.sh

NodeRedCmd = FlowsOfNoVolume

if [! -d /data/]
then
  echo "[Info] Save Flows to volume"
  # from https://nodered.org/docs/getting-started/running
  NodeRedCmd = -u /data/
else
  echo "[Warning] No Volume found Flows saved only in Container or not loaded form Volume"
fi

# run node-red in the backgrounf
/usr/bin/node-red $NodeRedCmd


# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0
