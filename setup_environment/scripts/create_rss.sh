#
# RSS 登録
#

#--------------------------------------------------------------------
# 事前準備
#--------------------------------------------------------------------
_server=$1
_cell=$2

# 福島テレビ
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "youtube",
  "site": "福島テレビ",
  "type": "2",
  "url": "UC9_ZCtgOk8dPC6boqZMNqbw"
}' -i -k

# 浪江町役場(新着)
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "lastCrawl": "2014-11-26T10:32:10+0900",
  "scraping": "namie_news",
  "site": "浪江町役場新着情報",
  "type": "1",
  "url": "http://www.town.namie.fukushima.jp/rss/rss10.xml?ef_id=1"
}' -i -k

# 浪江町役場(重要なお知らせ)
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "lastCrawl": "",
  "scraping": "namie_news",
  "site": "浪江町役場重要なお知らせ",
  "type": "1",
  "url": "http://www.town.namie.fukushima.jp/rss/rss10.xml?ef_id=3"
}' -i -k

# 復興支援員ブログ
curl -X POST "https://${_server}/${_cell}/data/odata/rss" -H "Authorization: Bearer ${_token}" -H "Accept:application/json" -d '
{
  "defaultTag": "%E3%81%9D%E3%81%AE%E4%BB%96",
  "scraping": "blog_jugem",
  "site": "浪江町復興支援員宮城県駐在ブログ",
  "type": "1",
  "url": "http://namiemiyagi.jugem.jp/?mode=rss"
}' -i -k

# つながろうなみえ
curl -X POST 'https://${_server}/${_cell}/data/odata/rss' \
-H "Authorization: Bearer ${token}" \
-H "Accept:application/json" \
-d '
{
  "defaultTag": "facebook",
  "site": "つながろうなみえ",
  "type": "7",
  "url": "tsunagaro.namie"
}' -i -k

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
