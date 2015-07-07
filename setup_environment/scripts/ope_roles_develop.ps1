echo "---------------------------"
echo "Start running application"

$_server = "test.namie-tablet.org"
$_cell = "kizuna01"

echo ""
echo "---------------------------"
echo "server name: $_server"
echo "cell name: $_cell"

echo ""
echo "---------------------------"
echo "Checking Arguments."
echo $args.length
if($args.length -lt 4)
{
echo "第1引数：管理者アカウント、第2引数：管理者パスワード、第3引数：変更アカウント、第4引数：追加(add)or削除(del)or参照(chk)"
echo "引数がたりないため、終了します。"
exit
}

if ($args[3] -eq "add")
{
echo "admin権限を付与します。"
}
elseif ($args[3] -eq "del")
{
echo "admin権限を削除します。"
}
elseif ($args[3] -eq "chk")
{
echo "現在の内容を表示します。"
}
else
{
echo "引数に誤りがあるため、終了します。"
exit
}


$_loginId = $args[0]
$_loginPass = $args[1]
echo "login Id: $_loginId"

$_editLoginId = $args[2]

echo ""
echo "---------------------------"
echo "Get authorization token."

$_token = curl -X POST "https://$_server/$_cell/__auth" -d "grant_type=password&username=$_loginId&password=$_loginPass" -k -s

$_access = $_token -replace '^.*access_token":"(.*)","refresh.*','$1'

echo ""
echo "---------------------------"
echo "Search LoginId."
echo ""

echo $_access

$work = 'https://' + $_server + '/' + $_cell + '/data/odata/personal?$filter=loginId%20eq%20%27' + $_editLoginId + '%27&$select=__id,loginId'

$_id = curl -X GET $work -H "Authorization:Bearer $_access" -H "Accept:application/json" -k

$_idget = $_id -replace '^.*"__id":"(.*)","__published":.*','$1'

if($_idget -eq '{"d":{"results":[]}}')
{
echo "一致するユーザがいないため、終了します。"
exit
}

echo ""
echo "---------------------------"
echo "Put Authority of operations management app."
echo ""

if($args[3] -eq "chk")
{
curl -X GET "https://$_server/$_cell/data/odata/personal(%27$_idget%27)" -H "Authorization:Bearer $_access" -H "Accept:application/json" -i -k
}

elseif($args[3] -eq "add")
{
curl -X MERGE "https://$_server/$_cell/data/odata/personal(%27$_idget%27)" -d '{\"roles\":\"admin\"}' -H "Authorization:Bearer $_access" -H "Accept:application/json" -i -k
}

elseif($args[3] -eq "del")
{
curl -X MERGE "https://$_server/$_cell/data/odata/personal(%27$_idget%27)" -d '{\"roles\":\"\"}' -H "Authorization:Bearer $_access" -H "Accept:application/json" -i -k
}

echo ""
echo "End running application"
echo "---------------------------"
