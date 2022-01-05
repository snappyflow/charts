#!/bin/bash
set -x -e
PG_CONN_PARAMETERS="-h ${POSTGRES_HOST} -p 5432 -U ${POSTGRES_USER}"
DUMP_ARGS="-Fc"

MYDATE=$(date +%d-%B-%Y)
MONTH=$(date +%B)
YEAR=$(date +%Y)

BACKUPDIR=/${BASEDIR}/${YEAR}/${MONTH}
mkdir -p ${BACKUPDIR}
cd ${BACKUPDIR}


echo "Backup running to $BACKUPDIR"


# Loop through each pg database backing it up

for DB in ${PG_MULTI_DB}; do
  echo "Backing up $DB"
  FILENAME=${BACKUPDIR}/${DB}.${MYDATE}.dmp


  PGPASSWORD=${POSTGRES_PASS} pg_dump ${PG_CONN_PARAMETERS} ${DUMP_ARGS}  -d ${DB} > ${FILENAME}

  echo "Backing up $FILENAME"

done

if [ "${REMOVE_BEFORE:-}" ]; then
  TIME_MINUTES=$((REMOVE_BEFORE * 24 * 60))
  echo "Removing following backups older than ${REMOVE_BEFORE} days"
  find /${BASEDIR}/* -type f -mmin +${TIME_MINUTES} -delete

fi
