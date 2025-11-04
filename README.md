**smart Backup Automation Script**

 A. Project Overview
This project is a **smart automated backup tool** written in Bash.  
The script automatically creates compressed backups of a specified folder, verifies them with a checksum, and manages old backups according to a retention policy (daily, weekly, monthly).  

Why it is useful:
- Protects important files from accidental deletion or corruption.  
- Saves disk space by keeping only a limited number of backups.  
- Provides verification to ensure backups are not corrupted.  
- Supports dry-run mode, logging, and optional restore.

---

## B. How to Use It

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/backup-system.git
   cd backup-system

2 Make the script executable:
  chmod +x backup.sh

3 Ensure folders exist (logs, backups, test_data):
  mkdir -p logs backups/daily backups/weekly backups/monthly test_data/documents

  Basic Usage Examples

*Create a backup:
./backup.sh ./test_data/documents

 *Dry run (simulate backup without creating files):
    ./backup.sh --dry-run ./test_data/documents
   
* List all backups:
   ./backup.sh --list


*Restore a backup:
./backup.sh --restore backups/daily/backup-2025-11-03-1607.tar.gz --to restored_files

C. **How It Works**
1. Backup Creation

The script compresses the folder using tar -czf into a .tar.gz file.
Excluded folders (like .git, node_modules, .cache) are skipped using patterns from backup.config.
Each backup is timestamped, e.g., backup-2025-11-03-1607.tar.gz.

2. **Checksum Verification**
*A SHA256 checksum is generated for every backup:
    sha256sum backup-2025-11-03-1607.tar.gz > backup-2025-11-03-1607.tar.gz.sha256

*Verification ensures backup integrity:
   sha256sum -c backup-2025-11-03-1607.tar.gz.sha256

 3. **Backup Rotation** (Deletion)

Daily: Keep last 7 backups.

Weekly: Keep last 4 backups.

Monthly: Keep last 3 backups.

The script deletes the oldest backups beyond these limits to save space.
All actions are logged in logs/backup.log.

4.**Folder Structure**

backup-system/
├── backup.sh
├── backup.config
├── logs/
│   └── backup.log
├── backups/
│   ├── daily/
│   ├── weekly/
│   └── monthly/
└── test_data/
    └── documents/
        ├── file1.txt
        └── file2.txt

 D. **Design Decisions**

Why Bash: Lightweight, portable, and ideal for server environments.

Checksum verification: Ensures backups are not corrupted before deletion.

Lock file: Prevents multiple scripts from running simultaneously.

Logging: Allows tracking all operations and errors.

Challenges faced:

*Handling old backup deletion while respecting daily/weekly/monthly retention.
*Ensuring the script doesn’t crash if a folder is missing or unreadable.

Solutions:

*Used ls -1t with tail to remove oldest backups.
*Added error checks for missing folders, permission issues, and disk space.

Testing
1. Test Setup

Created a test folder with files:

echo "Hello Backup" > test_data/documents/file1.txt
echo "Important File" > test_data/documents/file2.txt

2. Creating a Backup
./backup.sh ./test_data/documents


Output:

[INFO] Starting backup of ./test_data/documents
[SUCCESS] Backup created: ./backups/daily/backup-2025-11-03-1607.tar.gz
[INFO] Checksum verified successfully

3. Dry Run Mode
./backup.sh --dry-run ./test_data/documents


Output:

[INFO] [DRY-RUN] Would create backup at ./backups/daily/backup-2025-11-03-1609.tar.gz

4. Automatic Deletion

Simulated old backups and ran the script.

Old backups beyond retention were deleted:

[INFO] Deleted old backup: backup-2025-10-15-0900.tar.gz

5. Restore Backup
./backup.sh --restore backups/daily/backup-2025-11-03-1607.tar.gz --to restored_files

Files restored successfully:

restored_files/file1.txt
restored_files/file2.txt

6. Error Handling

Backup a non-existent folder:

./backup.sh nonexistent_folder
[ERROR] Source folder not found: nonexistent_folder


 **Known Limitations**

Weekly and monthly rotation is currently count-based, not date-based (could improve by checking calendar weeks/months).

Incremental backup is not implemented (currently full backups only).

Email notifications are simulated by writing to a file, not sent to real email.

Examples

1 Creating a backup

2 Creating multiple backups over several days (simulate by copying backup files with fake dates)

3 Automatic deletion of old backups

4 Restoring from a backup

5 Dry run mode

6 Error handling with a non-existent folder


**Conclusion**
   This project automates the process of creating, verifying, and managing backups using a Bash script. It
   ensures data safety through checksum verification, logging, and automatic cleanup of old backups. We
   learned how to use shell scripting for automation, data integrity checks, and backup management —
   building a strong foundation for real-world data protection systems...





