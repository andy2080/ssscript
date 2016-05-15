#!/bin/sh
#chkconfig: 2345 80 90
#description: manage the shadowsocks manyuser\n

SERVICE=SSScript
SNAME=server.py
WORKPATH=/root/shadowsocks/shadowsocks
PROG="$WORKPATH/$SNAME"
RETVAL=0

start() {
    service iptables stop
    #check the service status first
    if [ -f /var/lock/subsys/$SNAME ]
    then
        echo -e "$SERVICE is already started!\n"
        exit 0;
    else
        echo -e $"Starting $SERVICE... \n"
        cd $WORKPATH
    	nohup python $SNAME >& /dev/null &
        RETVAL=$?
       	[ $RETVAL -eq 0 ] && touch /var/lock/subsys/$SNAME
    	return $RETVAL
    fi
}

stop() {
    echo -e "Stopping $SERVICE ...\n"
    pkill -f $SNAME
    rm -rf /var/lock/subsys/$SNAME
}

status() {
    if [ -f /var/lock/subsys/$SNAME ]
    then
        echo -e "$SERVICE is running!\n"
    else
        echo -e "$SERVICE is not running!\n"
    fi
}

case "$1" in
start)
  start
  ;;
stop)
  stop
  ;;
reload|restart)
  stop
  start
  ;;
status)
  status
  RETVAL=$?
  ;;
*)
    echo $"Usage: ssscript {start|stop|restart|status}"
    exit 1
esac

exit $RETVAL
