#!/bin/sh

# exit with error code 1 if the env variable DATABASE_URL is not set or empty

if [ -z "$DATABASE_URL" ] && [ -z ${DATABASE_URL} ]
then
  echo "DATABASE_URL is not set. The vector tile server can not connect to PostGIS server."
  exit 1 # exit with error code 1 if the env variable DATABASE_URL is not set or empty
fi



i=0
PROG="martin"
if [ -z "$SLEEP_SECS" ]
then
  SLEEP_SECS=900
fi

if [ ! -z "$REMOTE_CFG" ]
then
echo "***********************************************************"
echo "****************     REMOTE MODE     **********************"
echo "***************  SLEEP_SEC=$SLEEP_SECS    ******************"
echo "***********************************************************"
      CFG="./cfg.yaml"
      TMP_CONFIG="./tmp_cfg.yaml"
      CONFIG="/etc/martin/config.yaml"

      while [ true ]
      do
        # copy cfg if does not exist
        if [ ! -f "$CFG" ]
        then
            #curl $AZURE_CFG -o $CFG --silent
            cp $CONFIG $CFG
        fi
        #download temp cfg
        curl $REMOTE_CFG -o $TMP_CONFIG --silent
        CFG_FILE_SIZE=$(stat -c%s "$CFG")
        NEW_CFG_FILE_SIZE=$(stat -c%s "$TMP_CONFIG")
        MARTIN_PID=$(pidof $PROG)
        #check if the re remote has been changed and update
        if [ $NEW_CFG_FILE_SIZE != $CFG_FILE_SIZE ]
        then
            echo "Changes have been detected in remote config file ... syncing..."
            envsubst < $TMP_CONFIG > $CONFIG
            mv $TMP_CONFIG $CFG
            if [ ! -z "$MARTIN_PID" ]
            then
                echo "restarting $PROG process (pid=$MARTIN_PID)"
                kill -15 $MARTIN_PID
                $PROG --config $CONFIG &

              else
                  echo "starting $PROG"
                  #$PROG $CONFIG &
                  $PROG --config $CONFIG &
            fi

        else
            if [ ! -f "$CONFIG" ]
            then
                echo "creating local config file $CONFIG from remote config "
                envsubst < $TMP_CONFIG > $CONFIG
                mv $TMP_CONFIG  $CFG

            fi

            if [ -z "$MARTIN_PID" ]
            then
                echo "starting $PROG with $CONFIG "
                $PROG --config $CONFIG &
            fi

        fi
        sleep $SLEEP_SECS
      done
else
echo "***********************************************************"
echo "*********************     DB MODE    **********************"
echo "***********************************************************"
$PROG

fi


