#!/bin/bash

ZABBIX_USER=""
ZABBIX_PASS=""
ZABBIX_API="http://ip/api_jsonrpc.php"
HOSTNAME_ZABBIX=$1
IP_ZABBIX=$2
HOST_PORT=$3

ZABBIX_AUTH_TOKEN=$(curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${ZABBIX_USER}"\",\"password\":\""${ZABBIX_PASS}"\"},\"auth\": null,\"id\":0}" $ZABBIX_API |  jq -r .result)

curl -s -H  'Content-Type: application/json-rpc' -d "
{
    \"jsonrpc\": \"2.0\",
    \"method\": \"host.create\",
    \"params\": {
        \"host\": \"${HOSTNAME_ZABBIX}\",
        \"interfaces\": [
            {
                \"type\": 2,
                \"main\": 1,
                \"useip\": 1,
                \"ip\": \"${IP_ZABBIX}\",
                \"dns\": \"\",
                \"port\": \"${HOST_PORT}\",
                \"details\": {
                    \"version\": 2,
                    \"community\": \"{\$SNMP_COMMUNITY}\",
                    \"bulk\": 0
                }
            }
        ],
        \"groups\": [
            {
                \"groupid\": 21
            }
        ]
    },
    \"auth\": \"${ZABBIX_AUTH_TOKEN}\",
    \"id\": 1
}" ${ZABBIX_API}


for i in $(cat lista.txt) ; do  HOSTNAME_LISTA=$(echo $i | cut -d\; -f1) ; IP_ZABBIX=$(echo $i | cut -d\; -f2)  ; ./createhost.sh ${HOSTNAME_LISTA} ${IP_ZABBIX}  ; done
