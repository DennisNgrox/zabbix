#!/bin/bash

ZABBIX_USER=""
ZABBIX_PASS=""
ZABBIX_API="http://ip/api_jsonrpc.php"
HOSTNAME_ZABBIX=$1
IP_ZABBIX=$2

ZABBIX_AUTH_TOKEN=$(curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${ZABBIX_USER}"\",\"password\":\""${ZABBIX_PASS}"\"},\"auth\": null,\"id\":0}" $ZABBIX_API |  jq -r .result)

curl -s -H  'Content-Type: application/json-rpc' -d "
{
    \"jsonrpc\": \"2.0\",
    \"method\": \"hostgroup.create\",
    \"params\": {
        \"name\": \"$1\"
    },
    \"auth\": \"${ZABBIX_AUTH_TOKEN}\",
    \"id\": 1
}" ${ZABBIX_API}


for i in $(cat grupo.txt) ; do  HOSTNAME_LISTA=$(echo $i| cut -d\; -f1) ; ./group.sh ${HOSTNAME_LISTA}"  ; done
