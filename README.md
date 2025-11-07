
##🗂️ Backup-System**

 **Project Overview**

Backup-System is a lightweight Bash-based automated backup solution designed to create, verify, and manage backups of important directories.
It compresses data into timestamped .tar.gz archives, generates SHA256 checksums for file integrity verification, and automatically deletes older backups according to a configurable retention policy.

It supports dry-run simulation, restore functionality, and maintains detailed logs of all actions.

**B. Features**

* Create compressed .tar.gz backups with timestamps

* Generate .sha256 checksum files for integrity verification

* Automatic cleanup (rotation) of old backups

* Dry-run mode to test without writing files

* Restore backups to any directory

* Logging of every action (success and errors)

* Simple, dependency-free Bash script (works on any Linux/macOS system)
  
**C. Prerequisites**

*Linux or macOS terminal (Windows users can use WSL)

*Bash shell

*Core utilities: tar, gzip, sha256sum, awk, df, du

*(Optional) cron for automated scheduling

**D. Repository Files**

* File / Folder	Description
* backup.sh	Main backup automation script
* backup.config	Configuration file for destination, exclusions, and retention policy
* logs/backup.log	Log file storing backup activity
* backups/	Folder where all backup archives and checksums are stored
* test_data/	Sample data folder for testing
* README.md	Documentation (this file)

 **Folder structure:**
 BACKUP-SYSTEM/
├── backup.sh
├── backup.config
├── logs/
│   └── backup.log
├── backups/
│   ├── backup-2025-11-03-1457.tar.gz
│   └── backup-2025-11-03-1457.tar.gz.sha256
└── test_data/
    ├── documents/
    │   ├── file1.txt
    │   ├── file2.txt
    │   └── notes.txt
    └── media/
        └── data.log


**E. Installation**
1. Clone or copy the project:
    git clone https://github.com/yourusername/backup-system.git
cd backup-system

2 . Make the script executable:
    chmod +x backup.sh

3.  Review and edit configuration file:
    nano backup.config

**F. Configuration (backup.config)**
 Example configuration:
  # === Backup Configuration ===

# Destination for all backup archives
BACKUP_DESTINATION=./backups

# Folders to exclude from backup (comma-separated)
EXCLUDE_PATTERNS=".git,node_modules,.cache"

# Backup retention policy
DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3

# (Optional) Email notification (not implemented yet)
EMAIL_NOTIFICATION=""


**G. Usage**
1️⃣ Create a Backup
   bash backup.sh test_data

2️⃣ Dry Run (simulate backup)
   bash backup.sh --dry-run test_data

3️⃣ List Existing Backups
    bash backup.sh --list

 4️⃣ Restore a Backup
    bash backup.sh --restore backups/backup-2025-11-03-1457.tar.gz --to ./restored_data

  **H. Backup Process Explained**
   
    When you run the script:

    * It checks for configuration and available disk space.

    * Compresses your source folder into a .tar.gz archive.
    
    * Generates a .sha256 file to verify backup integrity.

    * Logs all actions in logs/backup.log.

    * Automatically deletes older backups beyond the configured retention limit.

   
   **I. Verify Backup Integrity**
    1. You can verify the backup file using:
       sha256sum -c backups/backup-2025-11-03-1457.tar.gz.sha256

     * If it outputs:
        OK
        then the backup is verified successfully.

  **J. Logs**
  
  *All logs are stored in:
    logs/backup.log

*Example log entries:
 [2025-11-03 14:57:58] SUCCESS: Backup created: ./backups/backup-2025-11-03-1457.tar.gz
[2025-11-03 14:57:58] INFO: Checksum verified successfully
[2025-11-03 14:57:58] INFO: Cleaning up old backups...
[2025-11-03 14:57:58] SUCCESS: Backup process completed.

**K. Suggested Improvements**

* Add email notifications on completion

* Add cloud upload (AWS S3, Google Drive)

* Implement file encryption (GPG)

* Advanced incremental backup system


 **L. Author**

Sindhu Punyamurthi
Project: Automated Backup System (DevOps Practice Project)

**M. License**

This project is open for educational and personal use.
You can adapt or extend it freely under the MIT-style license.





    



       







