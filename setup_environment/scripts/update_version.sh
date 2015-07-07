#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io タブレットアプリ バージョン更新スクリプト
#

_unitUserName=${UNIT_USER_NAME}
_unitUserPassword=${UNIT_USER_PASSWORD}
_server=$1
_cell=$2
_cordovaDir=$3

if [ -z "${_unitUserName}" ]; then
    echo Not set UNIT_USER_NAME enviroment.
    exit 1
fi

#--------------------------------------------------------------------
# Token取得
#--------------------------------------------------------------------
RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
_token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`

curl -X PUT "https://${_server}/${_cell}/data/public/news/config.xml" --data-binary "@${_cordovaDir}/news/config.xml" -H "Authorization:Bearer ${_token}" -i -k -s
curl -X PUT "https://${_server}/${_cell}/data/public/letter/config.xml" --data-binary "@${_cordovaDir}/letter/config.xml" -H "Authorization:Bearer ${_token}" -i -k -s
curl -X PUT "https://${_server}/${_cell}/data/public/dojo/config.xml" --data-binary "@${_cordovaDir}/dojo/config.xml" -H "Authorization:Bearer ${_token}" -i -k -s
