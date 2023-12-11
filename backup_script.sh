#!/bin/bash

# Set variables
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/home/ec2-user/devdatabase"
S3_BUCKET="s3://testingbucket1252/DataBackupIFile"

# Create a backup of important system files (example: /etc)
sudo tar -czvf $BACKUP_DIR/system_backup_$TIMESTAMP.tar.gz /etc

# Create a backup of important data files (adjust paths accordingly)
tar -czvf $BACKUP_DIR/data_backup_$TIMESTAMP.tar.gz /home/ec2-user/

# Upload backups to AWS S3 bucket
aws s3 cp $BACKUP_DIR/system_backup_$TIMESTAMP.tar.gz $S3_BUCKET/
aws s3 cp $BACKUP_DIR/data_backup_$TIMESTAMP.tar.gz $S3_BUCKET/

# Cleanup: Remove local backups older than 7 days
find $BACKUP_DIR -name "*.tar.gz" -type f -mtime +7 -exec rm {} \;

echo "Backup completed and uploaded to S3 bucket.
