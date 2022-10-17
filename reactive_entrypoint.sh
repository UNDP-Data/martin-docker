#!/bin/sh

if [ -f .env ]; then
    # Load Environment Variables
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')

fi


# exit with error code 1 if the env variable DATABASE_URL is not set or empty

if [ -z "$DATABASE_URL" ] && [ -z ${DATABASE_URL} ]
then
  echo "DATABASE_URL is not set. The vector tile server can not connect to PostGIS server."
  exit 1 # exit with error code 1 if the env variable DATABASE_URL is not set or empty
fi



i=0
PROG="martin"
SLEEP_SEC=10
if [ ! -z "$AZURE_CFG" ]
then
      echo "***********************************************************"
      echo "***** starting martin server in remote mode ***************"
      echo "***** changes to remote config will be synced **************"
      echo "***** to server every $SLEEP_SEC seconds ******************"
      echo "***********************************************************"
      CFG="./cfg.yaml"
      TMP_CONFIG="./tmp_cfg.yaml"


      while [ true ]
      do
        # downlaod cfg if does not exist
        if [ ! -f "$CFG" ]
        then
            curl $AZURE_CFG -o $CFG --silent
        fi
        #download temp cfg
        curl $AZURE_CFG -o $TMP_CONFIG --silent
        CFG_FILE_SIZE=$(stat -c%s "$CFG")
        NEW_CFG_FILE_SIZE=$(stat -c%s "$TMP_CONFIG")
        MARTIN_PID=$(pidof $PROG)
        #check if the re remote has been changed and update
        if [ $NEW_CFG_FILE_SIZE != $CFG_FILE_SIZE ]
        then
            echo "Changes have been detected in remote config file ... syncing..."
            envsubst < $TMP_CONFIG > $CONFIG
            mv $TMP_CONFIG $CFG
            if [ ! -z "$MARTIN_PID" ];
            then
                echo "restarting $PROG process (pid=$MARTIN_PID)"
                kill -15 $MARTIN_PID
                $PROG --config $CONFIG &

              else
                  echo "starting $PROG $MARTIN_PID"
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

            if [ -z "$MARTIN_PID" ];
            then
                $PROG --config $CONFIG &
            fi

        fi
        sleep $SLEEP_SEC
      done
else
      if [ ! -z "$CONFIG" ]
      then
          echo "Using local config $CONFIG"
          $PROG --config $CONFIG
      else
          echo "No config was detected connecting to the DB"
          $PROG
      fi
fi


