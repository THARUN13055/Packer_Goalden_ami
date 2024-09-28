#!/bin/bash

SCRIPT_PATH="/opt/s3_log_backup/log_automation.sh"  
LOG_PATH="/var/log/s3sync.log"

CRON_JOB_6AM="0 6 * * * /bin/bash $SCRIPT_PATH >> $LOG_PATH 2>&1"
CRON_JOB_6PM="0 18 * * * /bin/bash $SCRIPT_PATH >> $LOG_PATH 2>&1"

(crontab -l | grep -q "$SCRIPT_PATH") && echo "Cron jobs already exist." && exit 0

(crontab -l 2>/dev/null; echo "$CRON_JOB_6AM") | crontab -
(crontab -l 2>/dev/null; echo "$CRON_JOB_6PM") | crontab -

echo "Cron jobs added for 6 AM and 6 PM."
