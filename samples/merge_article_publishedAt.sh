
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
