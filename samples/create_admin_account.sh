#
# admin01アカウントを作成する
# admin01アカウントの権限はallとする
#
#■Cell作成
curl -X POST "https://test.example.com/__ctl/Cell" -d "{\"Name\":\"kizuna01\"}" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

#■Account作成
curl -X POST "https://test.example.com/kizuna01/__ctl/Account" -d "{\"Name\":\"admin\"}" -H "X-Dc-Credential:admin01" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

#■Role作成
curl -X POST "https://test.example.com/kizuna01/__ctl/Role" -d "{\"Name\":\"role_kizuna_admin\"}" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

#■ACL登録
curl -X ACL "https://test.example.com/kizuna01/" -d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://test.example.com/kizuna01/__role/__/\">  <D:ace>    <D:principal>      <D:href>role_kizuna_admin</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:all/>      </D:privilege>    </D:grant></D:ace><D:ace>    <D:principal>      <D:href>role_kizuna_service</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:event/>      </D:privilege>    </D:grant></D:ace></D:acl>" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

#■Account - Role $links作成
curl -X POST "https://test.example.com/kizuna01/__ctl/Account('admin')/\$links/_Role" -d "{\"uri\":\"https://test.example.com/kizuna01/__ctl/Role('role_kizuna_admin')\"}" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

#■パスワード認証
curl -X POST "https://test.example.com/kizuna01/__auth" -d "grant_type=password&username=admin&password=admin01" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept:application/json" -i -k -s

