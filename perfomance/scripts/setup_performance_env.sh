#!/bin/sh

_unitUserName=${UNIT_USER_NAME}
_unitUserPassword=${UNIT_USER_PASSWORD}
_server=$1
_cell=$2
_target=$3

RESP=`curl -X POST "https://${_server}/servicemanager/__auth" -d "grant_type=password&username=${_unitUserName}&password=${_unitUserPassword}&dc_target=https://${_server}/" -i -k -s`
_token=`echo $RESP | sed -e 's/^.*access_token":"\(.*\)","refresh.*$/\1/'`


curl "https://${_server}/${_target}/data/dav/2015" -H "Authorization:Bearer ${_token}" -X MKCOL -i -k
curl "https://${_server}/${_target}/data/dav/2015/02-03" -H "Authorization:Bearer ${_token}" -X MKCOL -i -k
curl "https://${_server}/${_target}/data/dav/2015/02-04" -H "Authorization:Bearer ${_token}" -X MKCOL -i -k
curl "https://${_server}/${_target}/data/dav/2015/01-24" -H "Authorization:Bearer ${_token}" -X MKCOL -i -k

images=(
"2015/02-04/aa472fd7-760a-475a-8d66-18ed93b80d2e/3c371f6c-50df-44be-acab-56dc798e605a.jpg" \
"2015/02-04/c032fb24-9e9a-4953-bad5-324b78d43227/002ff9c3-4543-4769-8769-bd34589c329c.jpg" \
"2015/02-04/f473c084-8cef-4e19-93a2-df359caf55ed/e367d360-f4a4-4079-b8c4-89b924e535a9.jpg" \
"2015/02-03/201502031905159500/thumbnail.png" \
"2015/02-04/5773d1ce-e600-432a-bf6c-18cec08cf859/f3cf5afb-a3a2-4e6b-bb56-8b0ea50323d0.jpg" \
"2015/02-04/c74146bf-ba93-4b20-88f7-ea554ce2e365/bc2fce97-f6e0-4974-8c9b-a96fc16bdbf7.jpg" \
"2015/02-04/5486fba0-d5d6-47ef-bafe-a731437e92d3/4ce9237b-6865-42c9-978f-9e0ca3b678a0.jpg" \
"2015/02-04/e641800d-9d56-4391-bf12-2a959074bd38/481e3227-39e5-4bfb-9a73-7f1fdab3cfee.jpg" \
"2015/02-04/7575e90f-9437-4e02-9ead-055d9310e382/1d9c6db5-259a-44bb-b4c5-4e51435f8718.jpg" \
"2015/02-04/2835638c-59e8-4ff5-894f-3c258b2dae65/f6e2d024-46eb-4ab5-b1d0-5e66b75ef9a6.jpg" \
"2015/02-04/34bedf22-0b85-47c8-b92f-1ffdd39f7944/41f65e32-c03d-417e-83e4-ce88cfeefffb.jpg" \
"2015/02-04/6dfd909b-d188-4bfb-b3ab-f73d714e26f6/bcf8ff46-5f51-4606-b7b8-9dbb6a0f24f9.jpg" \
"2015/02-04/7cef1832-436f-40bf-85b4-cd8747c1f4bb/15a96f35-66b7-47e4-9054-505340f49252.jpg" \
"2015/02-03/201502031224058020/thumbnail.png" \
"2015/02-03/fe35cca9-4efa-4b7d-b8c2-879c88e2fb14/4daf6a8c-2cba-49a3-ab9f-a408d81a55f7.jpg" \
"2015/02-03/d1d8712c-2623-440f-9aa5-0e6c762a33e5/6b96b162-b6f8-4417-b2ec-210ec61f80f9.jpg" \
"2015/02-03/f6d105bd-be1a-4cc5-824d-84613f38e24d/6211fb3e-93be-44dc-91ae-388b958a2b81.jpg" \
"2015/02-03/62365e14-e225-4d82-bdca-e0b90cc8d6d4/5e56b2be-8b25-433c-9166-4f879524dab7.jpg" \
"2015/02-03/81b4d1dc-5776-4e1f-94ce-791a92ce688e/3fa8d2b3-3bf9-4019-b561-658b9329e269.jpg" \
"2015/02-03/6350b6a7-698d-4cdf-9c3d-6a4adc158934/6cc68571-483c-4dc7-bcf3-d9fc4c92953c.jpg" \
"2015/02-03/08170b32-580f-411c-b0ff-17ea3b45cf67/695aab6f-1e3b-4555-aa17-d91fb7e8a932.jpg" \
"2015/01-24/201501242250529560/thumbnail.png" \
"2015/02-03/4eb469a8-fac9-4b90-9cf3-2a3c95b8b34c/80b744e2-4405-4e92-8744-fbf0c98963b1.jpg" \
"2015/02-03/eeb57574-7ef0-488d-a72e-06263cae7a89/e06a5598-4043-4082-95d9-9165d55548f3.jpg" \
"2015/02-03/609d0641-4c00-4aa1-8164-f8c15b701942/b53b4393-6603-439f-91b5-e2df208677ff.jpg" \
"2015/02-04/33821281-0b2d-46f2-b993-9dbbbe5fb84e/1053265_782797478471365_1595587257671888366_o.jpg" \
    )

for imagePath in ${images[@]}
do
    echo "-----------GET image ${imagePath}-----------"
	curl -X GET "https://${_server}/${_cell}/data/dav/${imagePath}" -H "Authorization:Bearer ${_token}" -s -O
	filename=${imagePath##*/}
	filepath=${imagePath%/*}
	echo "-----------MKCOL image path ${filepath}-----------"
	curl -X MKCOL "https://${_server}/${_target}/data/dav/${filepath}" -H "Authorization:Bearer ${_token}" -i -k
    echo "-----------PUT image ${filename}-----------"
	curl -X PUT "https://${_server}/${_target}/data/dav/${imagePath}" -H "Authorization:Bearer ${_token}" --data-binary @${filename} -i -k
done
