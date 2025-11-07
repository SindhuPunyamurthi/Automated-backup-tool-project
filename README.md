
##🗂️ Backup-System**

 #Project Overview

Backup-System is a lightweight Bash-based automated backup solution designed to create, verify, and manage backups of important directories.
It compresses data into timestamped .tar.gz archives, generates SHA256 checksums for file integrity verification, and automatically deletes older backups according to a configurable retention policy.

It supports dry-run simulation, restore functionality, and maintains detailed logs of all actions.

##B. Features

* Create compressed .tar.gz backups with timestamps

* Generate .sha256 checksum files for integrity verification

* Automatic cleanup (rotation) of old backups

* Dry-run mode to test without writing files

* Restore backups to any directory

* Logging of every action (success and errors)

* Simple, dependency-free Bash script (works on any Linux/macOS system)
  
##C. Prerequisites

*Linux or macOS terminal (Windows users can use WSL)

*Bash shell

*Core utilities: tar, gzip, sha256sum, awk, df, du

*(Optional) cron for automated scheduling

