#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io タブレットアプリ バージョン情報削除スクリプト
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

curl -X DELETE "https://${_server}/${_cell}/data/public/news/config.xml" -H "Authorization:Bearer ${_token}" -i -k -s
curl -X DELETE "https://${_server}/${_cell}/data/public/letter/config.xml" -H "Authorization:Bearer ${_token}" -i -k -s
curl -X DELETE "https://${_server}/${_cell}/data/public/dojo/config.xml" -H "Authorization:Bearer ${_token}" -i -k -s

