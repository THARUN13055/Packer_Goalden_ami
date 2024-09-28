#!/bin/bash

LOG_PATH="/opt/tomcat/bin/logs/"

# Define your S3 bucket
S3_BUCKET="s3://paynpro-java-log-backup"

DATE=$(date +"%d-%m-%Y")

HOUR=$(date +"%H")

if [[ ! -d "/opt/s3logs" ]]; then
    sudo mkdir -p /opt/s3logs
    echo "Directory /opt/s3logs created."
else
    echo "Directory /opt/s3logs already exists."
fi

if [ "$HOUR" -eq 06 ]; then
    TIME_FOLDER="6-am"
elif [ "$HOUR" -eq 18 ]; then
    TIME_FOLDER="6-pm"
else
    echo "The script should only run at 10 AM or 6 PM."
    exit 1
fi

S3_PATH="$S3_BUCKET/$DATE/$TIME_FOLDER/"

aws s3 sync $LOG_PATH "$S3_PATH"

echo "Synced at $(date) to $S3_PATH" | sudo tee -a /opt/s3logs/sync.log >/dev/null

