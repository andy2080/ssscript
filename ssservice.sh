#chkconfig: 2345 24 25\n
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
        echo "$SERVICE is already started!"
        exit 0;
    else
        echo -n $"Starting $SERVICE... "
        cd $WORKPATH
    	nohup python $SNAME >& /dev/null &
        RETVAL=$?
       	[ $RETVAL -eq 0 ] && touch /var/lock/subsys/$SNAME
    	return $RETVAL
    fi
}

stop() {
    echo "Stopping $SERVICE ..."
    pkill -f $SNAME
    rm -rf /var/lock/subsys/$SNAME
}

status() {
    if [ -f /var/lock/subsys/$SNAME ]
    then
        echo "$SERVICE is running!"
        exit 0;
    else
        echo "$SERVICE is not running!"
        exit 0;
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
    echo $"Usage: $0 {start|stop|restart|status}"
    exit 1
esac

exit $RETVAL
