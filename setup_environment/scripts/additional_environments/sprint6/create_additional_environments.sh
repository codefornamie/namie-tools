#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io環境構築スクリプト
#

#--------------------------------------------------------------------
# 事前準備
#--------------------------------------------------------------------
_unitUserName=${UNIT_USER_NAME}
_unitUserPassword=${UNIT_USER_PASSWORD}
_server=$1
_cell=$2
_box="data"

#--------------------------------------------------------------------
# パラメタチェック
#--------------------------------------------------------------------
if [ $# -ne 2 ]; then
    echo usage: $0 server-url cellName
    exit 1
fi
if [ -z "${_unitUserName}" ]; then
    echo Not set UNIT_USER_NAME enviroment.
    exit 1
fi

if [ -z "${_unitUserPassword}" ]; then
    echo Not set UNIT_USER_PASSWORD enviroment.
    exit 1
fi

#--------------------------------------------------------------------
# Token取得
#--------------------------------------------------------------------
RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
_token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`

#--------------------------------------------------------------------
# EntityType(newspaper_holiday)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"newspaper_holiday\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

