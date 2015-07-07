
# admin01アカウントを作成する
# admin01アカウントの権限はallとする

# Cell作成
curl -X POST "https://test.example.com/__ctl/Cell" -d "{\"Name\":\"kizuna01\"}" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

# Account作成
curl -X POST "https://test.example.com/kizuna01/__ctl/Account" -d "{\"Name\":\"admin\"}" -H "X-Dc-Credential:admin01" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

# Role作成
curl -X POST "https://test.example.com/kizuna01/__ctl/Role" -d "{\"Name\":\"role_kizuna_admin\"}" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

# ACL登録
curl -X ACL "https://test.example.com/kizuna01/" -d "<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:acl xmlns:D=\"DAV:\" xml:base=\"https://test.example.com/kizuna01/__role/__/\">  <D:ace>    <D:principal>      <D:href>role_kizuna_admin</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:all/>      </D:privilege>    </D:grant></D:ace><D:ace>    <D:principal>      <D:href>role_kizuna_service</D:href>      </D:principal>    <D:grant>      <D:privilege>        <D:event/>      </D:privilege>    </D:grant></D:ace></D:acl>" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

# Account - Role $links作成
curl -X POST "https://test.example.com/kizuna01/__ctl/Account('admin')/\$links/_Role" -d "{\"uri\":\"https://test.example.com/kizuna01/__ctl/Role('role_kizuna_admin')\"}" -H "Authorization:Bearer devel-20141114" -H "Accept:application/json" -i -k -s

# パスワード認証
curl -X POST "https://test.example.com/kizuna01/__auth" -d "grant_type=password&username=admin&password=admin01" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept:application/json" -i -k -s

##########################################################
# Article
##########################################################

# Article内のYouTube一覧取得
curl -X GET 'https://test.example.com/kizuna01/data/odata/article?$filter=type+eq+2' \
-H "Authorization: Bearer devel-20141114" \
-H "Accept: application/json"

# 一件取得
curl -X GET 'https://test.example.com/kizuna01/data/odata/article(%272e8492ca7cb04330b6a47d7d35b94ac4%27)' \
-H "Authorization: Bearer devel-20141114" \
-H "Accept: application/json"

# publishedAt の 変更(MERGE)
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/article(%272e8492ca7cb04330b6a47d7d35b94ac4%27)' \
-H "Authorization: Bearer devel-20141114" \
-d '
{
  "publishedAt": "2014-11-28"
}' -i -v

# 特定の日付のpublishedAt検索
curl -X GET 'https://test.example.com/kizuna01/data/odata/article?$publishAt+eq+%272014-12-11%27' \
-H "Authorization: Bearer devel-20141114" \
-H "Accept: application/json"

# 復興支援員ブログ(宮城)のみの検索
curl -X GET 'https://test.example.com/kizuna01/data/odata/article?$filter=url+eq+%27http%3A%2F%2Fnamiemiyagi.jugem.jp%2F%3Feid%3D3%27' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -i -v

# つながろうなみえのみの検索
curl -X GET 'https://test.example.com/kizuna01/data/odata/article?$inlinecount=allpages&$top=1000&$select=url&$filter=site+eq+%27%E3%81%A4%E3%81%AA%E3%81%8C%E3%82%8D%E3%81%86%E3%81%AA%E3%81%BF%E3%81%88%27' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -i -v

##########################################################
# Configuration 登録
#
# 新聞配信時刻
##########################################################

curl -X POST 'https://test.example.com/kizuna01/data/odata/configuration' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "__id": "PUBLISH_TIME",
  "value": "17:00",
  "label": "新聞配信時刻"
}' -i -v


##########################################################
# RSS
##########################################################
# RSS一覧取得
curl -X GET 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -i -v

# 福島テレビ登録
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "youtube",
  "site": "福島テレビ",
  "type": "2",
  "url": "UC9_ZCtgOk8dPC6boqZMNqbw"
}' -i -v

# 福島民報登録
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "lastCrawl": "2014-11-27T09:47:29+0900",
  "scraping": "minpo",
  "site": "福島民報",
  "type": "1",
  "url": "http://headlines.yahoo.co.jp/rss/fminpo-loc.xml"
}' -i -v

# 浪江町役場登録
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "lastCrawl": "2014-11-26T10:32:10+0900",
  "scraping": "namie_news",
  "site": "浪江町役場新着情報",
  "type": "1",
  "url": "http://www.town.namie.fukushima.jp/rss/rss10.xml?ef_id=1"
}' -i -v

# 復興支援員ブログ登録
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "%E3%81%9D%E3%81%AE%E4%BB%96",
  "scraping": "blog_jugem",
  "site": "浪江町復興支援員宮城県駐在ブログ",
  "type": "1",
  "url": "http://namiemiyagi.jugem.jp/?mode=rss"
}' -i -v

# つながろうなみえ登録
curl -X POST 'https://test.example.com/kizuna01/data/odata/rss' -H "Authorization: Bearer devel-20141114" -H "Accept:application/json" -d '
{
  "defaultTag": "%E7%9C%8C%E5%86%85%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9",
  "scraping": "",
  "site": "つながろうなみえ",
  "type": "1",
  "url": "https://www.facebook.com/feeds/page.php?id=135789423172177&format=rss20"
}' -i -v


# 復興支援員ブログの lastCrawl削除
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%27ed9341070fd64383b8288259df5e5b86%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# 福島テレビの lastCrawl削除
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%279610c4e697504283b8256d889dcdc925%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# 福島テレビの lastCrawl削除
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%27d7a58c22ae254499a6400583985a1078%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# 福島民報の lastCrawl削除
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%27fdeff17683974b6e940e2069db960082%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# つながろうなみえ の lastCrawl を削除
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%274c31ba7199fc41b5b862d45bc9b8b429%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v
