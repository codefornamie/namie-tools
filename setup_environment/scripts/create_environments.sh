#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io 本番環境構築スクリプト
#

export _unitUserName=${UNIT_USER_NAME}
export _unitUserPassword=${UNIT_USER_PASSWORD}
export _server=$1
export _cell=$2
export _box="data"

if [ -z "${_unitUserName}" ]; then
    echo Not set UNIT_USER_NAME enviroment.
    exit 1
fi

#--------------------------------------------------------------------
# Token取得
#--------------------------------------------------------------------
RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
export _token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`

#--------------------------------------------------------------------
# personium.io 定義情報作成
#--------------------------------------------------------------------
sh ./create_cell.sh ${_server} ${_cell} ${_box}

#--------------------------------------------------------------------
# 初期データ作成
#--------------------------------------------------------------------
sh ./create_rss.sh ${_server} ${_cell}
sh ./create_configuration.sh ${_server} ${_cell}
sh ./create_newspaper_holiday.sh ${_server} ${_cell}
sh ./create_dojo_movie.sh ${_server} ${_cell}
