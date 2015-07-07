#!/bin/sh
#
# 浪江町タブレット　きずな再生プロジェクト
# personium.io環境構築スクリプト
#

#--------------------------------------------------------------------
# エンティティ作成
# make_property <entity>
# entity: エンティティ名
#--------------------------------------------------------------------
make_entity () {
    ENAME="$1"
    curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
    -d "{\"Name\":\"$ENAME\"}" \
    -H "Authorization:Bearer ${_token}" \
    -X POST -i -k
}

#--------------------------------------------------------------------
# プロパティ作成
# make_property <entity> <property_name> <type>
# entity: エンティティ名
# property_name: プロパティ名
# type: プロパティの型
#    Edm.Int32
#    Edm.String
#    Edm.Single
#    Edm.Boolean
#--------------------------------------------------------------------
make_property () {
    ENAME="$1"
    PNAME="$2"
    PTYPE="$3"
    curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/Property" \
    -d "{
    \"Name\":\"$PNAME\",
    \"_EntityType.Name\":\"$ENAME\",
    \"Type\": \"$PTYPE\",
    \"Nullable\": true}" \
    -H "Authorization:Bearer ${_token}" \
    -X POST -i -k
}

#--------------------------------------------------------------------
# 事前準備
#--------------------------------------------------------------------
# _unitUserName=${UNIT_USER_NAME}
# _unitUserPassword=${UNIT_USER_PASSWORD}
_server=$1
_cell=$2
_box=$3

# デフォルトユーザー (動作確認用)
_user="ukedon"
_password="d7fdb631f3820d0d39b0bf20e775d577"
_role="role_kizuna_service"

# 運用操作用ユーザー
_user_admin="admin"
_password_admin=${ADMIN_USER_PASSWORD}
_role_admin="role_kizuna_admin"

# ゲストユーザ
_user_guest="guest"
_password_guest="84983c60f7daadc1cb8698621f802c0d"
_role_guest="role_kizuna_guest"

#--------------------------------------------------------------------
# パラメタチェック
#--------------------------------------------------------------------
if [ $# -ne 3 ]; then
    echo usage: $0 server-url cellName boxName
    exit 1
fi
# if [ -z "${_unitUserName}" ]; then
#    echo Not set UNIT_USER_NAME enviroment.
#    exit 1
# fi

if [ -z "${_password_admin}" ]; then
    echo Not set ADMIN_USER_PASSWORD enviroment.
    exit 1
fi

#--------------------------------------------------------------------
# Token取得
#--------------------------------------------------------------------
#RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
#_token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`

#--------------------------------------------------------------------
# Cell作成
#--------------------------------------------------------------------
curl "https://${_server}/__ctl/Cell" \
-d "{\"Name\":\"${_cell}\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account作成(ukedon)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account" \
-d "{\"Name\":\"${_user}\"}" \
-H "X-Dc-Credential:${_password}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account作成(admin)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account" \
-d "{\"Name\":\"${_user_admin}\"}" \
-H "X-Dc-Credential:${_password_admin}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account作成(guest)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account" \
-d "{\"Name\":\"${_user_guest}\"}" \
-H "X-Dc-Credential:${_password_guest}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Box作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Box" \
-d "{\"Name\":\"${_box}\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# ODataコレクション作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\"?><D:mkcol xmlns:D=\"DAV:\" xmlns:dc=\"urn:x-dc1:xmlns\"><D:set><D:prop><D:resourcetype><D:collection/><dc:odata/></D:resourcetype></D:prop></D:set></D:mkcol>" \
-H "Authorization: Bearer ${_token}" \
-X MKCOL -i -k

#--------------------------------------------------------------------
# WebDAV(dav)コレクション作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/dav" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\"?><D:mkcol xmlns:D=\"DAV:\" xmlns:dc=\"urn:x-dc1:xmlns\"><D:set><D:prop><D:resourcetype><D:collection/></D:resourcetype></D:prop></D:set></D:mkcol>" \
-H "Authorization: Bearer ${_token}" \
-X MKCOL -i -k

#--------------------------------------------------------------------
# WebDAV(public)コレクション作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/public" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\"?><D:mkcol xmlns:D=\"DAV:\" xmlns:dc=\"urn:x-dc1:xmlns\"><D:set><D:prop><D:resourcetype><D:collection/></D:resourcetype></D:prop></D:set></D:mkcol>" \
-H "Authorization: Bearer ${_token}" \
-X MKCOL -i -k

#--------------------------------------------------------------------
# Serviceコレクション作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/api" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\"?><D:mkcol xmlns:D=\"DAV:\" xmlns:dc=\"urn:x-dc1:xmlns\"><D:set><D:prop><D:resourcetype><D:collection/><dc:service/></D:resourcetype></D:prop></D:set></D:mkcol>" \
-H "Authorization: Bearer ${_token}" \
-X MKCOL -i -k

#--------------------------------------------------------------------
# /davコレクション内に、スライドショー用のサブコレクション(slideshow)を作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/dav/slideshow" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\"?><D:mkcol xmlns:D=\"DAV:\" xmlns:dc=\"urn:x-dc1:xmlns\"><D:set><D:prop><D:resourcetype><D:collection/></D:resourcetype></D:prop></D:set></D:mkcol>" \
-H "Authorization: Bearer ${_token}" \
-X MKCOL -i -k

#--------------------------------------------------------------------
# Role作成(role_kizuna_service)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Role" \
-d "{\"Name\":\"${_role}\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Role作成(role_kizuna_admin)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Role" \
-d "{\"Name\":\"${_role_admin}\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Role作成(role_kizuna_guest)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Role" \
-d "{\"Name\":\"${_role_guest}\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account - Role リンク(ukedon - role_kizuna_admin)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account('${_user}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role('${_role_admin}')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account - Role リンク(admin - role_kizuna_admin)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account('${_user_admin}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role('${_role_admin}')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Account - Role リンク(guest - role_kizuna_guest)
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Account('${_user_guest}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role('${_role_guest}')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Box - Role リンク
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Box('${_box}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role('${_role}')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Box - Role リンク
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Box('${_box}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role('${_role_admin}')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# Box - Role リンク
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/__ctl/Box('${_box}')/\$links/_Role" \
-d "{\"uri\":\"https://${_server}/${_cell}/__ctl/Role('${_role_guest}')\"}" \
-H "Authorization: Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# adminセルへACL設定
#--------------------------------------------------------------------

curl "https://${_server}/${_cell}" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\">  <D:ace>    <D:principal>      <D:href>${_role_admin}</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:all/>      </D:privilege>    </D:grant></D:ace><D:ace>    <D:principal>      <D:href>${_role}</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:event/>      </D:privilege>    </D:grant></D:ace><D:ace>    <D:principal>      <D:href>${_role_guest}</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:event/>      </D:privilege>    </D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# odataコレクションへACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_guest}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# WebDAVコレクション(dav)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/dav" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_guest}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# WebDAVコレクション(public)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/public" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_guest}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:all/></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# Serviceコレクション(api)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/api" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:exec/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege><D:privilege><D:exec/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# EntityType(event)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"event\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(rss)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"rss\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(article)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"article\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(favorite)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"favorite\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(radiation)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"radiation\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(recommend)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"recommend\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(personal)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"personal\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(configuration)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"configuration\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(dojo_movie)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"dojo_movie\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(achievement)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"achievement\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(slideshow)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"slideshow\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(newspaper_holiday)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"newspaper_holiday\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

#--------------------------------------------------------------------
# EntityType(radiation_cluster)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"radiation_cluster\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

make_property radiation_cluster numSample Edm.Int32
make_property radiation_cluster maxValue Edm.Int32
make_property radiation_cluster minValue Edm.Int32
make_property radiation_cluster errorCode Edm.Int32
make_property radiation_cluster averageValue Edm.Int32
make_property radiation_cluster maxLatitude Edm.Int32
make_property radiation_cluster minLatitude Edm.Int32
make_property radiation_cluster minLongitude Edm.Int32
make_property radiation_cluster maxLongitude Edm.Int32
make_property radiation_cluster isFixedStation Edm.Boolean

#--------------------------------------------------------------------
# EntityType(radiation_log)作成
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata/\$metadata/EntityType" \
-d "{\"Name\":\"radiation_log\"}" \
-H "Authorization:Bearer ${_token}" \
-X POST -i -k

make_property radiation_log latitude Edm.Int32
make_property radiation_log longitude Edm.Int32
make_property radiation_log altitude Edm.Int32
make_property radiation_log value Edm.Int32

#--------------------------------------------------------------------
# EntityType(character_message)作成
#--------------------------------------------------------------------
make_entity character_message

make_property character_message type Edm.Int32
make_property character_message weight Edm.Int32
make_property character_message enabled Edm.Boolean
