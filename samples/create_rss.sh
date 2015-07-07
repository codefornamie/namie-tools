#
# RSS 登録
#
# 福島テレビ
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "youtube",
  "site": "福島テレビ",
  "type": "2",
  "url": "UC9_ZCtgOk8dPC6boqZMNqbw"
}' -i -v

# 福島民報
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "lastCrawl": "2014-11-27T09:47:29+0900",
  "scraping": "minpo",
  "site": "福島民報",
  "type": "1",
  "url": "http://headlines.yahoo.co.jp/rss/fminpo-loc.xml"
}' -i -v

# 浪江町役場
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "lastCrawl": "2014-11-26T10:32:10+0900",
  "scraping": "namie_news",
  "site": "浪江町役場新着情報",
  "type": "1",
  "url": "http://www.town.namie.fukushima.jp/rss/rss10.xml?ef_id=1"
}' -i -v

# 復興支援員ブログ
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "%E3%81%9D%E3%81%AE%E4%BB%96",
  "scraping": "blog_jugem",
  "site": "浪江町復興支援員宮城県駐在ブログ",
  "type": "1",
  "url": "http://namiemiyagi.jugem.jp/?mode=rss"
}' -i -v
