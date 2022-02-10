#! /bin/bash

ZABBIX_USER=""
ZABBIX_PASS=""
ZABBIX_API="http://zabbix/api_jsonrpc.php"
HOST_ZABBIX=$1


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
    \"method\": \"template.massadd\",
    \"params\": {
        \"templates\": [
            {
                \"templateid\": \"10186\"
            },
             {
                \"templateid\": \"10803\"
            }

        ],
        \"hosts\": [
            {
                \"hostid\": ${GET_HOST_ID}
            }
        ]
    },
    \"auth\": \"${ZABBIX_AUTH_TOKEN}\",
    \"id\": 1
}" ${ZABBIX_API}

for i in $(cat listatemplates.txt) ; do  HOST_ZABBIX=$(echo $i | cut -d\: -f1) ; ./host.sh ${HOST_ZABBIX} ; done
