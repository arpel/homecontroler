#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
export PATH

COFFEE_EXE=coffee
APPLICATION_DIR=/home/pi/aloneGIT
APPLICATION_SCRIPT=RFsimple.coffee

if ps -ef | grep -v grep | grep RFsimple ; then
        /bin/echo "Running" >> $APPLICATION_DIR/cron.log
        exit 0
else
        cd $APPLICATION_DIR
        /usr/bin/nohup $COFFEE_EXE $APPLICATION_DIR/$APPLICATION_SCRIPT &
        /bin/echo "Dead" >> $APPLICATION_DIR/cron.log
        exit 0
fi

