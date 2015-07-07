#!/bin/sh
if [ $# -lt 2 ]; then
	echo "usage: $0 <login_id> <action_id> ..." 1>&2
	exit 1
fi

loginid=$1
shift
action_ids=$*

now="`date '+%Y-%m-%dT%H:%M:%S.000+0900'`"

userid="`getuserid $loginid`"
if [ -z "$userid" ]; then
    userid="userid_$loginid"
    (postdata -e personal -d '{
"__id": "'$userid'",
"createdAt": "'$now'",
"updatedAt": "'$now'",
"deletedAt": null,
"fontSize": "middle",
"loginId": "'$loginid'",
"showLastPublished": null
    }'; printf "od ")&
fi

cnt=1
for action_id in $action_ids
do
    sleep 0.1
    (postdata -e achievement -d '{
"action": "'$action_id'",
"count": "1",
"lastActionDate": "'$now'",
"memberId": "0",
"type": "dojo_solved",
"ownerId": "'$userid'",
"userId": "'$userid'",
"createdAt": "'$now'",
"updatedAt": "'$now'",
"deletedAt": null
    }'; printf "%02d " $cnt)&
    cnt="`expr $cnt + 1`"
done
wait