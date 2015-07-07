#!/bin/bash
USERNAME=${atlassian_user}
PASSWORD=${atlassian_password}
INSTANCE=${atlassian_url_jira}
LOCATION=${atlassian_backuplocation}

TODAY=`date +%Y%m%d`
wget --user=$USERNAME --password=$PASSWORD -t 0 --retry-connrefused https://${INSTANCE}/webdav/backupmanager/JIRA-backup-${TODAY}.zip -P $LOCATION >/dev/null 2>/dev/null
