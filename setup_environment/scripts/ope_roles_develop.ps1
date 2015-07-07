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
echo "��1�����F�Ǘ��҃A�J�E���g�A��2�����F�Ǘ��҃p�X���[�h�A��3�����F�ύX�A�J�E���g�A��4�����F�ǉ�(add)or�폜(del)or�Q��(chk)"
echo "����������Ȃ����߁A�I�����܂��B"
exit
}

if ($args[3] -eq "add")
{
echo "admin������t�^���܂��B"
}
elseif ($args[3] -eq "del")
{
echo "admin�������폜���܂��B"
}
elseif ($args[3] -eq "chk")
{
echo "���݂̓��e��\�����܂��B"
}
else
{
echo "�����Ɍ�肪���邽�߁A�I�����܂��B"
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
echo "��v���郆�[�U�����Ȃ����߁A�I�����܂��B"
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
