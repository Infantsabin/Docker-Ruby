#!/bin/sh

if [ $RACK_ENV == development ]
then
   echo $RACK_ENV
   rake db:reset
   exec puma
else
   adduser \
		--disabled-password \
		--gecos "" \
		--no-create-home \
		"$PGUSER"
   chmod 700 /postgres/data
   chown -R $PGUSER:$PGUSER /postgres
   echo "$PGUSER:$PGPASS" | chpasswd
   exec su-exec $PGUSER initdb -D /postgres/data
   echo "host all all 0.0.0.0/0 md5" >> /postgres/data/pg_hba.conf

   su-exec $PGUSER pg_ctl start -D /postgres/data
   createdb -h $PGHOST -p $PGPORT -U $PGUSER $PGDB
   rake db:migrate
   exec puma
   exec tail -f /dev/null
fi