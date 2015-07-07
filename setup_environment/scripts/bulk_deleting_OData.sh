#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io EntitySetデータ一括削除スクリプト
#

_unitUserName=${UNIT_USER_NAME}
_unitUserPassword=${UNIT_USER_PASSWORD}
_server=$1
_cell=$2
_entity=$3

if [ -z "${_unitUserName}" ]; then
    echo Not set UNIT_USER_NAME enviroment.
    exit 1
fi

#--------------------------------------------------------------------
# Token取得
#--------------------------------------------------------------------
RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
_token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`

curl -X GET "https://${_server}/${_cell}/data/odata/${_entity}?\$top=10000&\$select=__id" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" -i -k -s |\
tail -1 |\
sed -e 's/.,"__id":"/\n/g' |\
sed -e 's/".*$//' |\
grep -v '\{' |\
while read id
do
    echo "delete odata. id: ${id}"
    curl -X DELETE \
    "https://${_server}/${_cell}/data/odata/${_entity}('${id}')" \
    -H "Authorization:Bearer ${_token}" -i -k -s
done
