🗂️ Automated Backup System
📘 A. **Project Overview**

This project is an automated backup system written in Bash.
It automatically creates compressed backups (.tar.gz) of important folders, verifies their integrity with SHA256 checksums, and removes old backups based on a retention policy.

It helps to keep data safe, reduce manual effort, and save disk space by deleting older backups.

⚙️ B. **How to Use It**
🔧 Installation Steps

Clone or copy this project folder to your system.

Make sure you have bash and tar installed (default on Linux/macOS).

Open a terminal inside the project folder:

cd ~/BACKUP-SYSTEM


**Make the script executable**:
 chmod +x backup.sh

▶️ Basic Usage Examples
1️⃣ Create a Backup
bash backup.sh test_data

2️⃣ Dry Run (Simulate backup without creating files)
bash backup.sh --dry-run test_data

3️⃣ List Available Backups
bash backup.sh --list

4️⃣ Restore a Backup
bash backup.sh --restore backups/backup-2025-11-03-1457.tar.gz --to ./restored_data

🧩 Command Options
Option	Description
--dry-run	Simulates the backup without creating files.
--list	Shows all available backups.
--restore <file> --to <folder>	Restores the specified backup to a target folder.
(no option)	Creates a new backup from the provided source folder.

**🧠 C. How It Works**
🔄 Backup Rotation
The script keeps only the latest backups according to:

7 daily backups
4 weekly backups
3 monthly backups

Older backups beyond this count are automatically deleted.

**🔒 Checksum (Integrity Verification)**

Each backup generates a .sha256 file containing a unique fingerprint.
Example:

backup-2025-11-03-1457.tar.gz
backup-2025-11-03-1457.tar.gz.sha256
This ensures the backup hasn’t been corrupted or changed.

**Folder Structure**
BACKUP-SYSTEM/
├── backup.config        # Configuration file
├── backup.sh            # Main script
├── backups/             # Generated backup files
│   ├── backup-2025-11-03-1457.tar.gz
│   └── backup-2025-11-03-1457.tar.gz.sha256
├── logs/                # Log history
│   └── backup.log
└── test_data/           # Sample source folder
    ├── documents/
    │   ├── file1.txt
    │   ├── file2.txt
    │   └── notes.txt
    └── media/
        └── data.log

🧩 **D. Design Decisions**

Bash Script: Simple, portable, and works on most Unix-like systems.

SHA256 Checksum: More secure than MD5 for verifying file integrity.

Retention Policy: Prevents disk overflow by deleting old backups automatically.

Lock Mechanism: Ensures only one backup process runs at a time.

🧪 **E. Testing**
✅ Tests Performed:

Created multiple backups at different times.

Verified that .tar.gz and .sha256 files are generated.

Simulated backup using --dry-run.

Tested restore with --restore and verified files were recovered.

Checked cleanup: older backups are deleted automatically after exceeding the limit.

🧾 Example Output
[2025-11-03 14:53:28] SUCCESS: Backup created: ./backups/backup-2025-11-03-1453.tar.gz
[2025-11-03 14:53:28] INFO: Checksum verified successfully
[2025-11-03 14:53:28] INFO: Cleaning up old backups...
[2025-11-03 14:53:28] SUCCESS: Backup process completed.

⚠️ **F. Known Limitations**

Works only on Linux/macOS (not directly on Windows without WSL).

No email notifications implemented yet (placeholder in config).

Only basic file exclusion patterns supported.

Does not yet include automated restore testing.

📌 **Example Summary**

✅ Created and verified multiple backups

✅ Automatically deleted older backups

✅ Tested restore and dry-run

✅ All logs stored in logs/backup.log
