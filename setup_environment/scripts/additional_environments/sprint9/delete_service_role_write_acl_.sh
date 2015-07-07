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
# odataコレクションへACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/odata" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_service}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
-H "Authorization: Bearer ${_token}" \
-X ACL -i -k

#--------------------------------------------------------------------
# WebDAVコレクション(dav)へACL設定
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/${_box}/dav" \
-d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://${_server}/${_cell}/__role/${_box}/\"><D:ace><D:principal><D:href>${_role}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_service}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace><D:ace><D:principal><D:href>${_role_admin}</D:href></D:principal><D:grant><D:privilege><D:read/></D:privilege><D:privilege><D:write/></D:privilege></D:grant></D:ace></D:acl>" \
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
