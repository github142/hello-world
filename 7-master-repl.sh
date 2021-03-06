#!/bin/bash
# Set mysql repl

master_ip=$1
db_rootpwd=$2
#master_ip=192.168.106.144
### Master add repl user and select file id
ssh root@$master_ip "mysql -u root -p$db_rootpwd << EOF
GRANT REPLICATION SLAVE,REPLICATION CLIENT ON *.* TO sync@'%' IDENTIFIED BY '123456';
flush privileges;
EOF
"
if [ $? != 0 ]; then
 echo '{"success":"false","msg":"add mysql repl user failed"}'
 exit
fi


# Get Master file name and position id
repl_info=`ssh root@$master_ip "mysql -u root -p$db_rootpwd -e 'show master status\G'"`
repl_file=`echo "$repl_info" |grep File|awk '{print $2}'`
repl_id=`echo "$repl_info" |grep Position: |awk '{print $2}'`

if [ $? = 0 ]; then
 echo "{\"success\":\"true\",\"msg\":\"mysql master repl get file and id  success\",\"file\":\""$repl_file\"",\"id\":\""$repl_id\""}"
else
 echo '{"success":"false","msg":"mysql master repl get file and id failed"}'
fi
