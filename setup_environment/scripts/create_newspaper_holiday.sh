#
# Configuration 登録
#
#--------------------------------------------------------------------
# 事前準備
#--------------------------------------------------------------------
_server=$1
_cell=$2

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
  echo ${date}
  curl "https://${_server}/${_cell}/data/odata/newspaper_holiday" \
  -H "Authorization:Bearer ${_token}" \
  -H "Accept:application/json" \
  -d "
  {
  \"__id\":\"${date}\",
  \"remarks\":\"土日\"
  }" -X POST -i -k
done < ${SAT_AND_SUN}
