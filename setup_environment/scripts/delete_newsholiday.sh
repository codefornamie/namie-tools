#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io タブレットアプリ 休刊日情報削除スクリプト
#

_unitUserName=${UNIT_USER_NAME}
_unitUserPassword=${UNIT_USER_PASSWORD}
_server=$1
_cell=$2
_date=$3
#--------------------------------------------------------------------
# パラメタチェック
#--------------------------------------------------------------------
if [ $# -ne 3 ]; then
    echo "usage: $0 server-url cellName targetDate(ex. 2015-02-11)"
    exit 1
fi
if [ -z "${_unitUserName}" ]; then
    echo Not set UNIT_USER_NAME enviroment.
    exit 1
fi

#--------------------------------------------------------------------
# Token取得
#--------------------------------------------------------------------
RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
_token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`

curl -X GET "https://${_server}//${_cell}/data/odata/newspaper_holiday('${_date}')" -H "Authorization:Bearer ${_token}" -i -k -s
curl -X DELETE "https://${_server}//${_cell}/data/odata/newspaper_holiday('${_date}')" -H "Authorization:Bearer ${_token}" -i -k -s

