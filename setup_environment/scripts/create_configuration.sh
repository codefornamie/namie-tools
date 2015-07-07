#
# Configuration 登録
#
#--------------------------------------------------------------------
# 事前準備
#--------------------------------------------------------------------
_server=$1
_cell=$2

#--------------------------------------------------------------------
# 新聞配信時刻
#--------------------------------------------------------------------
curl -X POST "https://${_server}/${_cell}/data/odata/configuration" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "__id": "PUBLISH_TIME",
  "value": "17:00",
  "label": "新聞配信時刻"
}' -i -k

#--------------------------------------------------------------------
# コンテンツラベルとラベルごとの色と優先順位
#--------------------------------------------------------------------
curl -X POST "https://${_server}/${_cell}/data/odata/configuration" -H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-d '{
  "__id":"COLOR_LABEL",
  "value": "[
{\"site\":\"浪江町復興支援員宮城県駐在ブログ\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#d68e1d\",\"label\":\"支援員レポート\"},
{\"site\":\"浪江町役場新着情報\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"},
{\"site\":\"浪江町役場重要なお知らせ\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"},
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
]",
  "label": "記事ラベル表示カラー",
  "category": "記事"
}
' \
 -i -k

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
