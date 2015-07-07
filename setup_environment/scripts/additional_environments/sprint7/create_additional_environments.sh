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
# レコード「COLOR_LABEL」作成(コンテンツラベルとラベルごとの色と優先順位)
#--------------------------------------------------------------------
curl -X POST "https://${_server}/${_cell}/data/odata/configuration" -H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-d '{
  "__id":"COLOR_LABEL",
  "value": "[
{\"site\":\"浪江町復興支援員宮城県駐在ブログ\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#d68e1d\",\"label\":\"支援員レポート\"},
{\"site\":\"浪江町役場新着情報\",\"type\":\"1\",\"priority\":\"4\",\"color\":\"#3bbedf\",\"label\":\"役場からのお知らせ\"},
{\"site\":\"つながろうなみえ\",\"type\":\"7\",\"priority\":\"4\",\"color\":\"#265fae\",\"label\":\"つながろうなみえ\"},
{\"site\":\"福島民報(トップニュース)\",\"type\":\"1\",\"priority\":\"6\",\"color\":\"#4da13f\",\"label\":\"福島民報\"},
{\"site\":\"福島民報(県内ニュース)\",\"type\":\"1\",\"priority\":\"6\",\"color\":\"#4da13f\",\"label\":\"福島民報\"},
{\"site\":\"福島民報(スポーツニュース)\",\"type\":\"1\",\"priority\":\"7\",\"color\":\"#4da13f\",\"label\":\"福島民報(スポーツ)\"},
{\"site\":\"福島テレビ\",\"type\":\"2\",\"priority\":\"5\",\"color\":\"#4da13f\",\"label\":\"福島テレビ\"},
{\"site\":\"おくやみ\",\"type\":\"8\",\"priority\":\"8\",\"color\":\"#adb9c1\",\"label\":\"お悔やみ\"},
{\"site\":\"写真投稿\",\"type\":\"6\",\"priority\":\"1\",\"color\":\"#d793be\",\"label\":\"みんなで投稿！撮れたて写真館\"},
{\"site\":\"イベント\",\"type\":\"11\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"レポート\",\"type\":\"12\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"イベント\",\"type\":\"3\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"レポート\",\"type\":\"4\",\"priority\":\"2\",\"color\":\"#d68e1d\",\"label\":\"町民ひろば\"},
{\"site\":\"記事\",\"type\":\"5\",\"priority\":\"3\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"},
{\"site\":\"写真投稿\",\"type\":\"6\",\"priority\":\"1\",\"color\":\"#d793be\",\"label\":\"みんなで投稿！撮れたて写真館\"},
{\"site\":\"イベント\",\"type\":\"9\",\"priority\":\"3\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"},
{\"site\":\"レポート\",\"type\":\"10\",\"priority\":\"3\",\"color\":\"#3bbedf\",\"label\":\"浪江町役場\"}
]",
  "label": "記事ラベル表示カラー",
  "category": "記事"
}
' \
 -i -k

#--------------------------------------------------------------------
# EntitySetに休刊日情報を作成(2015-2016, 土日、祝日)
# public_holiday.txt(祝日情報)とSat_and_Sun.txt(土日情報)をシェル実行と同一ディレクトリに配備しておくこと。
# ※祝日が土曜日または日曜日の場合は409エラーが発生することがある。
#--------------------------------------------------------------------

# 休刊日情報のファイルを読み込む
PUBLIC_HOLIDAY=./public_holiday.txt
SAT_AND_SUN=./Sat_and_Sun.txt

IFS=$', '
while read date remarks; do
  # newspaper_holidayへ祝日を登録
  curl "https://${_server}/${_cell}/data/odata/newspaper_holiday" \
  -H "Authorization:Bearer ${_token}" \
  -H "Accept:application/json" \
  -d "
  {
    \"__id\":\"${date}\",
    \"remarks\":\"${remarks}\"
  }" -X POST -i -k
done < ${PUBLIC_HOLIDAY}
IFS=$' \t\n'

while read date ; do
  # newspaper_holidayへ土日を登録
  curl "https://${_server}/${_cell}/data/odata/newspaper_holiday" \
  -H "Authorization:Bearer ${_token}" \
  -H "Accept:application/json" \
  -d "
  {
    \"__id\":\"${date}\",
    \"remarks\":\"土日\"
  }" -X POST -i -k
done < ${SAT_AND_SUN}

--------------------------------------------------------------------
# 本番適用用道場動画の登録
#--------------------------------------------------------------------
curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie1",
"videoId": "yoAvLbavwmA",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "1"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie2",
"videoId": "kT8Ga1MZqgU",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "2"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie3",
"videoId": "fSs2KlG_a4g",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "3"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie4",
"videoId": "RqcbGP0QgOU",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "4"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie5",
"videoId": "9Y_AFXHDP5Y",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "5"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie6",
"videoId": "H80p9SHIBlM",
"relationVideoId": "",
"level": "0",
"category": "",
"sequence": "6"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie7",
"videoId": "GR8CN7PubOk",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "7"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie8",
"videoId": "6Lfb8Ar6G14",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "8"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie9",
"videoId": "g07tg3pna2A",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "9"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie10",
"videoId": "AmJeXCuBqKY",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "10"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie11",
"videoId": "qLSiJEkYJh8",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "11"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie12",
"videoId": "I5RvFFusSv4",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "12"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie13",
"videoId": "1vMsM28uxFM",
"relationVideoId": "",
"level": "1",
"category": "",
"sequence": "13"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie14",
"videoId": "obKftIFwkvk",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "14"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie15",
"videoId": "Xi7tDRA2338",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "15"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie16",
"videoId": "5Z8WNrGjqCg",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "16"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie17",
"videoId": "w5EBoeXeFiE",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "17"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie18",
"videoId": "pX1pQ4nRceU",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "18"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie20",
"videoId": "0WPuYMFRutE",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "20"
}' -X POST -i -k

curl "https://${_server}/${_cell}/data/odata/dojo_movie" \
-H "Authorization:Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
"__id": "dojo_movie21",
"videoId": "ZaW2bvJtfP0",
"relationVideoId": "",
"level": "2",
"category": "",
"sequence": "21"
}' -X POST -i -k


#--------------------------------------------------------------------
# 従来の「つながろうなみえ」情報の削除
#--------------------------------------------------------------------
cmd=`curl -X GET "https://${_server}/${_cell}/data/odata/rss?\\$filter=site+eq+%27%E3%81%A4%E3%81%AA%E3%81%8C%E3%82%8D%E3%81%86%E3%81%AA%E3%81%BF%E3%81%88%27" \
-H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-i -v -s`

id=`echo $cmd | sed -e 's/^.*__id":"\(.*\)","__published.*$/\1/'`
echo "tsunagaro namie : ${id}"


curl -X DELETE "https://${_server}/${_cell}/data/odata/rss(%27${id}%27)" \
-H "Authorization: Bearer ${_token}" \
-i -k

#--------------------------------------------------------------------
# 新しい「つながろうなみえ」情報の登録
#--------------------------------------------------------------------
curl -X POST "https://${_server}/${_cell}/data/odata/rss" \
-H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-d '
{
  "defaultTag": "facebook",
  "site": "つながろうなみえ",
  "type": "7",
  "url": "tsunagaro.namie"
}' -i -k

#--------------------------------------------------------------------
# 従来の「福島民報」情報の削除
#--------------------------------------------------------------------
cmd=`curl -X GET "https://${_server}/${_cell}/data/odata/rss?\\$filter=site+eq+%27%e7%a6%8f%e5%b3%b6%e6%b0%91%e5%a0%b1%27" \
-H "Authorization: Bearer ${_token}" \
-H "Accept:application/json" \
-i -v -s`
id=`echo $cmd | sed -e 's/^.*__id":"\(.*\)","__published.*$/\1/'`
echo "fukushima minpo : ${id}"

curl -X DELETE "https://${_server}/${_cell}/data/odata/rss(%27${id}%27)" \
-H "Authorization: Bearer ${_token}" \
-i -k

#--------------------------------------------------------------------
# 新しい「福島民報」情報の登録
#--------------------------------------------------------------------

# おくやみ
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "scraping": "",
  "site": "おくやみ",
  "type": "8",
  "url": "http://minpo.newsmart.jp/deliveries/apis/okuyami_data/api.php?cat=all",
  "replaceCR": "<br/>"
}' -i -k

# 福島民報(県内ニュース)
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "site": "福島民報(県内ニュース)",
  "type": "1",
  "url": "http://www.minpo.jp/rss/localnews.xml",
  "scraping": "minpo"
}' -i -k

# 福島民報(トップニュース)
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "site": "福島民報(トップニュース)",
  "type": "1",
  "url": "http://www.minpo.jp/rss/localtopnews.xml",
  "scraping": "minpo"
}' -i -k

# 福島民報(スポーツニュース)
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "site": "福島民報(スポーツニュース)",
  "type": "1",
  "url": "http://www.minpo.jp/rss/sports_rss.xml",
  "scraping": "minpo"
}' -i -k

#
# スライドショー画像登録

# スライドショー画像
slideshowImages=(
    "02.2008_slide1.jpg" \
    "07.2007_slide2.jpg" \
    "13.2010_slide3.jpg" \
    "14.2007_slide4.jpg" \
    "24.2010_slide5.jpg" \
    "26.2008_slide6.jpg" \
    "30.2006_slide7.jpg" \
    "37.2009_slide8.jpg" \
    "43.2005_slide9.jpg" \
    "45.2008_slide10.jpg" \
    "2015_slide11.jpg"
    )
for imagePath in ${slideshowImages[@]}
do
    echo "upload image ${imagePath}"
    # WebDAVへファイルをアップロード
    curl "https://${_server}/${_cell}/data/dav/slideshow/${imagePath}" \
    -H "Authorization: Bearer ${_token}" \
    --data-binary "@slideshow/${imagePath}" -X PUT -i -k
    
    # sideshowエンティティへ登録
    curl "https://${_server}/${_cell}/data/odata/slideshow" \
    -d "{\"filename\":\"${imagePath}\",\"published\":\"1\"}" \
    -H "Authorization:Bearer ${_token}" \
    -X POST -i -k
done
