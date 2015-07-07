#!/bin/sh
pghome="`dirname $0`"
pgname="`basename $0`"

if [ $# -ne 1 ]; then
    echo "usage: $pgname <num_of_users>" 1>&2
    exit 1
fi

num_user=$1
cnt=0

prefix="mkachv_`date '+%Y%m%d%H%M%S'`"


while [ $cnt -lt $num_user ];
do
    if [ `expr $cnt % 10` -eq 0 ]; then
        echo "get token!"
        export TOKEN="`gettoken`"
    fi
    
    loginid="`printf "%s_%08d" $prefix $cnt`"
    printf "%s " $loginid

    sh $pghome/post_achievement.sh $loginid \
    kT8Ga1MZqgU \
    fSs2KlG_a4g \
    RqcbGP0QgOU \
    9Y_AFXHDP5Y \
    g07tg3pna2A \
    H80p9SHIBlM \
    6Lfb8Ar6G14 \
    GR8CN7PubOk \
    yoAvLbavwmA \
    5Z8WNrGjqCg \
    w5EBoeXeFiE \
    pX1pQ4nRceU \
    obKftIFwkvk \
    Xi7tDRA2338 \
    qLSiJEkYJh8 \
    AmJeXCuBqKY \
    I5RvFFusSv4 \
    1vMsM28uxFM \
    0WPuYMFRutE \
    ZaW2bvJtfP0
    echo
    cnt=`expr $cnt + 1`
done
