#!/bin/bash
USERNAME=${atlassian_user}
PASSWORD=${atlassian_password}
INSTANCE=${atlassian_url_jira}
LOCATION=${atlassian_backuplocation}

# Grabs cookies and generates the backup on the UI.
TODAY=`date +%Y%m%d`
COOKIE_FILE_LOCATION=jiracookie
curl --silent -u $USERNAME:$PASSWORD --cookie-jar $COOKIE_FILE_LOCATION https://${INSTANCE}/Dashboard.jspa --output /dev/null
BKPMSG=`curl -s --cookie $COOKIE_FILE_LOCATION --header "X-Atlassian-Token: no-check" -H "X-Requested-With: XMLHttpRequest" -H "Content-Type: application/json"  -X POST https://${INSTANCE}/rest/obm/1.0/runbackup -d '{"cbAttachments":"true" }' `
rm $COOKIE_FILE_LOCATION

#Checks if the backup procedure has failed
if [ `echo $BKPMSG | grep -i backup | wc -l` -ne 0 ]; then
#The $BKPMSG variable will print the error message, you can use it if you're planning on sending an email
echo "Failed to trigger backup. "
exit
fi
