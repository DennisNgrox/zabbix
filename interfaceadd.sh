#! /bin/bash

ZABBIX_USER=""
ZABBIX_PASS=""
ZABBIX_API="http://ip/api_jsonrpc.php"
HOST_ZABBIX=$1
HOST_IP=$2
HOST_PORT=$3


ZABBIX_AUTH_TOKEN=$(curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${ZABBIX_USER}"\",\"password\":\""${ZABBIX_PASS}"\"},\"auth\": null,\"id\":0}" $ZABBIX_API |  jq -r .result)


    GET_HOST_ID=$(curl -s -H 'Content-Type: application/json-rpc' -d "

    {
        \"jsonrpc\": \"2.0\",
        \"method\": \"host.get\",
        \"params\": {
           \"output\":[\"hostid\"],
         \"filter\": {
                \"host\": [
                    \"${HOST_ZABBIX}\"
                ]
            }
        },
        \"auth\": \"${ZABBIX_AUTH_TOKEN}\",
        \"id\": 1

    }" ${ZABBIX_API}| jq .result[].hostid
    )


curl -s -H 'Content-Type: application/json-rpc' -d "
{
    \"jsonrpc\": \"2.0\",
    \"method\": \"hostinterface.create\",
    \"params\": {
        \"hostid\": ${GET_HOST_ID},
        \"main\": \"0\",
        \"type\": \"2\",
        \"useip\": \"1\",
        \"ip\": \"${HOST_IP}\",
        \"dns\": \"\",
        \"port\": \"${HOST_PORT}\",
        \"details\": {
            \"version\": \"2\",
            \"bulk\": \"0\",
            \"community\": \"{$SNMP_COMMUNITY}\"
        }
    },
    \"auth\": \"${ZABBIX_AUTH_TOKEN}\",
    \"id\": 1
}" ${ZABBIX_API}


for i in $(cat lista) ; do  HOST_ZABBIX=$(echo $i | cut -d\: -f1) ; HOST_IP=$(echo $i | cut -d\: -f2) ; HOST_PORT=$(echo $i | cut -d\: -f3) ; ./host.sh ${HOSTNAME_LISTA} ${IP_LISTA} ${PORT_LIST}  ; done
