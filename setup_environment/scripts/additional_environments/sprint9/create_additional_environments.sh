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

_user="guest"
_password="84983c60f7daadc1cb8698621f802c0d"
_role="role_kizuna_guest"

_user_admin="ukedon"
_role_admin="role_kizuna_admin"
_role_service="role_kizuna_service"

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
# Account作成(guest)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account" \
-d "{\"Name\":\"${_user}\"}" \
-H "X-Dc-Credential:${_password}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Role作成(role_kizuna_guest)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Role" \
-d "{\"Name\":\"${_role}\", \"_Box.Name\":\"data\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account - Role リンク(guest - role_kizuna_guest)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account('${_user}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role(Name='${_role}',_Box.Name='data')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# adminセルへACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\">  <D:ace>    <D:principal>      <D:href>${_role_admin}</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:all/>      </D:privilege>    </D:grant></D:ace><D:ace>    <D:principal>      <D:href>${_role_service}</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:event/>      </D:privilege>    </D:grant></D:ace><D:ace>    <D:principal>      <D:href>${_role}</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:event/>      </D:privilege>    </D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# odataコレクションへACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_service}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# WebDAVコレクション(dav)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/dav" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role_service}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# WebDAVコレクション(public)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/public" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_service}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:all/></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# Serviceコレクション(api)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/api" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role_service}</D:href></D:principal><D:grant><D:privilege><D:exec/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege><D:privilege><D:exec/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# 1.レコード「COLOR_LABEL」作成(コンテンツラベルとラベルごとの色と優先順位)
# 2.コンテンツラベルとラベルごとの色と優先順位
# 3.写真投稿に”guestRestriction":"true”を追加
#--------------------------------------------------------------------
curl -X MERGE "https://${_server}/${_cell}/data/odata/configuration(%27COLOR_LABEL%27)" \
-H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-d '{
  "value": "[
{\"site\":\"浪江町復興支援員宮城県駐在ブログ\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#d68e1d\",\"label\":\"支援員レポート\"},
{\"site\":\"浪江町役場新着情報\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#3bbedf\",\"label\":\"役場からのお知らせ\"},
{\"site\":\"浪江町役場重要なお知らせ\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#3bbedf\",\"label\":\"役場からのお知らせ\"},
{\"site\":\"つながろうなみえ\",\"type\":\"7\",\"priority\":\"4\",\"color\":\"#265fae\",\"label\":\"つながろうなみえ\"},
{\"site\":\"福島民報(トップニュース)\",\"type\":\"1\",\"priority\":\"6\",\"color\":\"#4da13f\",\"label\":\"福島民報\",\"period\":60,\"guestRestriction\":\"true\"},
{\"site\":\"福島民報(県内ニュース)\",\"type\":\"1\",\"priority\":\"6\",\"color\":\"#4da13f\",\"label\":\"福島民報\",\"period\":60,\"guestRestriction\":\"true\"},
{\"site\":\"福島民報(スポーツニュース)\",\"type\":\"1\",\"priority\":\"7\",\"color\":\"#4da13f\",\"label\":\"福島民報(スポーツ)\",\"period\":60,\"guestRestriction\":\"true\"},
{\"site\":\"福島テレビ\",\"type\":\"2\",\"priority\":\"5\",\"color\":\"#4da13f\",\"label\":\"福島テレビ\"},
{\"site\":\"おくやみ\",\"type\":\"8\",\"priority\":\"8\",\"color\":\"#adb9c1\",\"label\":\"お悔やみ\",\"period\":60,\"guestRestriction\":\"true\"},
{\"site\":\"写真投稿\",\"type\":\"6\",\"priority\":\"1\",\"color\":\"#d793be\",\"label\":\"みんなで投稿！撮れたて写真館\",\"guestRestriction\":\"true\"},
{\"site\":\"イベント\",\"type\":\"11\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"レポート\",\"type\":\"12\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"イベント\",\"type\":\"3\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"レポート\",\"type\":\"4\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"記事\",\"type\":\"5\",\"priority\":\"3\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"},
{\"site\":\"イベント\",\"type\":\"9\",\"priority\":\"3\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"},
{\"site\":\"レポート\",\"type\":\"10\",\"priority\":\"3\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"}
]"
}
' \
 -i -k

#--------------------------------------------------------------------
# Account - Role リンク削除(ukedon - role_kizuna_service)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account('${_user_admin}')/\$links/_Role(Name='${_role_service}',_Box.Name='data')" \
-H "Authorization: Bearer ${_token}" \
-X DELETE -i -k

#--------------------------------------------------------------------
# Account - Role リンク登録(ukedon - role_kizuna_admin)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account('${_user_admin}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role(Name='${_role_admin}',_Box.Name='data')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# レコード「WIDGET_CHARACTER_PATTERN」作成(ウィジェットキャラクター画像選択)
#--------------------------------------------------------------------
curl -X POST "https://${_server}/${_cell}/data/odata/configuration" \
-H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-d '{
  "__id": "WIDGET_CHARACTER_PATTERN",
  "value": "ukedon_1_b",
  "createdAt": "",
  "updatedAt": "",
  "deletedAt": null,
  "label": "ウィジェット画像"
}' \
 -i -k

