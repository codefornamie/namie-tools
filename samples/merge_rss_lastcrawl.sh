#
# RSS Entity の LastCrawl 削除
#

# 復興支援員ブログ
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%27ed9341070fd64383b8288259df5e5b86%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# 福島テレビ
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%279610c4e697504283b8256d889dcdc925%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# 福島テレビ
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%27d7a58c22ae254499a6400583985a1078%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v

# 福島民報
curl -X MERGE 'https://test.example.com/kizuna01/data/odata/rss(%27fdeff17683974b6e940e2069db960082%27)' -H "Authorization: Bearer devel-20141114" -d '
{
  "lastCrawl": ""
}' -i -v
