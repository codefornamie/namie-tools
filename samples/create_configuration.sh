#
# Configuration 登録
#
# 新聞配信時刻

curl -X POST 'https://test.example.com/kizuna01/data/odata/configuration' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "__id": "PUBLISH_TIME",
  "value": "17:00",
  "label": "新聞配信時刻"
}' -i -v
