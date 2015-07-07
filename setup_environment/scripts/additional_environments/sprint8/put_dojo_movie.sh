#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io なみえ道場 動画置き換えスクリプト
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

--------------------------------------------------------------------
# 本番適用用道場動画の登録
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie1%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "NtUAbrgnmpM",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "1"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie2%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "wNMEFtW6ajI",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "2"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie3%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "9avv_hZIiAU",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "3"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie4%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "4UGD5aDmlCM",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "4"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie5%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "R4nVf2Up5xI",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "5"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie6%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "a9WjhLfLCsg",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "6"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie7%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "GR8CN7PubOk",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "7"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie8%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "6Lfb8Ar6G14",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "8"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie9%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "g07tg3pna2A",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "9"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie10%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "AmJeXCuBqKY",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "10"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie11%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "vCJYYXEeKf4",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "11"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie12%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "9g4VZOCzOyg",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "12"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie13%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "FtUWZ5m8xAs",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "13"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie14%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "1vMsM28uxFM",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "14"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie15%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "bXo7u0opXJc",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "15"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie16%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "PudXOjrEuZY",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "16"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie17%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "SKatLR0nzQg",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "17"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie18%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "B1UXobKZbWw",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "18"
}' -X PUT -i -k


curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie19",
"videoId": "w5EBoeXeFiE",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "19"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie20%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "5q8u0DGSeoE",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "20"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie(%27dojo_movie21%27)" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"videoId": "QrUi8TiWjG4",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "21"
}' -X PUT -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie22",
"videoId": "ZciNlsdfDoQ",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "22"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie23",
"videoId": "0WPuYMFRutE",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "23"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie24",
"videoId": "ZaW2bvJtfP0",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "24"
}' -X POST -i -k

