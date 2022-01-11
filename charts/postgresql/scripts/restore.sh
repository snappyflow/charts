#!/bin/bash
set -x -e
PG_CONN_PARAMETERS="-h ${POSTGRES_HOST} -p 5432 -U ${POSTGRES_USER}"
RESTORE_ARGS='-j 4'
eval "PG_MULTI_DB=($PG_MULTI_DB)"
eval "RESTORE_DAYS_BEFORE=($RESTORE_DAYS_BEFORE)"
for i in ${!PG_MULTI_DB[@]}; do
    TARGET_DB=${PG_MULTI_DB[$i]}
    echo $TARGET_DB
    echo $i
    TARGET_ARCHIVE=${RESTORE_DAYS_BEFORE[$i]}
    if [ ${RESTORE_DAYS_BEFORE[$i]}  == "0" ]
    then
        DATE=$(date +%d-%B-%Y)
        MONTH=$(date +%B)
        YEAR=$(date +%Y)
    else
        DATE=$(date --date="-${TARGET_ARCHIVE} day" +%d-%B-%Y)
        MONTH=$(date --date="-${TARGET_ARCHIVE} day" +%B)

        YEAR=$(date --date="-${TARGET_ARCHIVE} day" +%Y)
    fi
        if  [ ${COMPRESS}  == "false" ]
        then
          if [ ${FILEPATH}  == "true" ]
          then
            BACKUPDIR=$TARGET_ARCHIVE
          else

             BACKUPDIR=/backup/${YEAR}/${MONTH}/${TARGET_DB}.${DATE}.dmp
          fi
        else
          if [ ${FILEPATH}  == "true" ]
          then
            BACKUPDIR=$TARGET_ARCHIVE
          else
            BACKUPDIR=/backup/${YEAR}/${MONTH}/${TARGET_DB}.${DATE}.gz
          fi
        gzip -dkf ${BACKUPDIR}
        BACKUPDIR=/backup/${YEAR}/${MONTH}/${TARGET_DB}.${DATE}
        fi
        if [ -z "${BACKUPDIR:-}" ] || [ ! -f "${BACKUPDIR:-}" ]; then
                echo "BACKUPDIR needed."
                exit 1
    fi
    echo "Dropping target DB ${PG_MULTI_DB[$i]}"
        PGPASSWORD=${POSTGRES_PASS} dropdb ${PG_CONN_PARAMETERS} --if-exists ${TARGET_DB}



        echo "Recreate target DB ${PG_MULTI_DB[$i]}"
        PGPASSWORD=${POSTGRES_PASS} createdb ${PG_CONN_PARAMETERS} -O ${POSTGRES_USER} ${TARGET_DB}


        echo "Restoring dump file"
        # Only works if the cluster is different- all the credentials are the same
        #psql -f /backups/globals.sql ${TARGET_DB}
        PGPASSWORD=${POSTGRES_PASS} pg_restore ${PG_CONN_PARAMETERS} ${BACKUPDIR}  -d ${TARGET_DB} ${RESTORE_ARGS}
    if  [ ${COMPRESS}  == "true" ]
    then
      rm -rf ${BACKUPDIR}
    fi

done