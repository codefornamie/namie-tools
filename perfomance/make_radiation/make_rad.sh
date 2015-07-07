#!/bin/sh
if [ $# -ne 3 -a $# -ne 4 ]; then
	echo "usage: $0 <login_id> <num_of_samples> <pub_period(day)> [<pub_offset(day)>]" 1>&2
	exit 1
fi

export TOKEN="`gettoken`"
if [ $? -ne 0 ]; then
    echo "token error!" 1>&2
    exit
fi

loginid=$1
num_samples=$2
period=$3
if [ $# -eq 4 ]; then
	offset=$4
else
	offset=-$3
fi
cnt=0

userid="`getuserid -c $loginid`"

while [ "$num_samples" -gt 0 ];
do
    if [ `expr $num_samples % 10` -eq 0 ]; then
        echo "get token!"
        export TOKEN="`gettoken`"
    fi
    
	now="`randdate $period $offset`"
    ndate=${now:0:10}
    ntime=${now:11:8}
    if [ "$ntime" \< "16:00" ]; then
        pub="$ndate"
    else
        pub=`date -v+1d -j -f "%Y-%m-%d" $ndate "+%Y-%m-%d"`
    fi
    depub=`date -v+7d -j -f "%Y-%m-%d" $pub "+%Y-%m-%d"`

	id=`date "+%Y%m%d%H%M%S"`$cnt
	path="`date '+%Y/%m-%d/'`$id"

	printf "$cnt: $loginid: $now: "

	(postfile -p $path/test.jpg test.jpg; printf "i")&
	(postfile -p $path/thumbnail.jpg thumbnail.jpg; printf "t")&

	(postdata -e article -d '{
"__id": "'$id'",
"createUserId": "'`getuserid $loginid`'",
"createdAt": "'$now'",
"updatedAt": "'$now'",
"publishedAt": "'$pub'",
"depublishedAt": "'$depub'",
"description": "自動ツールで投稿。\nログインIDは'${loginid}'です。",
"nickname": "'$loginid'",
"imagePath": "'$path'",
"imageThumbUrl": "thumbnail.jpg",
"imageUrl": "test.jpg",
"site": "写真投稿",
"tags": "",
"type": "6"
}'; printf "o")&

    wait
	echo
	num_samples=`expr $num_samples - 1`
	cnt=`expr $cnt + 1`
done
