# fstest

## Overview
fstest is a bash script designed to check the status of a filesystem. It is a useful tool for system administrators and developers who need to verify the state of a filesystem quickly and efficiently. This script can determine if a filesystem is mounted, if it is writable, and if it is set to read-only mode.

## Features
- **Mount Check**: Verifies if the specified filesystem is mountRequirements
fstest requires the following tools to be present on your system: mountpoint, findmnt, and blockdev. The script checks for the availability of these tools and will exit with an error message if any are missing.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Contributing
Contributions are welcome. Please feel free to fork the repository and submit pull requests.

Acknowledgments
Special thanks to everyone who contributes to this project and provides feedback.ed.
- **Writability Check**: Checks if the filesystem is writable by attempting to create a test file.
- **Read-Only Check**: Determines if the filesystem or the device on which it is mounted is set to read-only mode. This is useful for identifying issues where a filesystem may unexpectedly be in a read-only state.
- **Error Reporting**: Provides clear and concise error reporting, indicating whether the filesystem is not mounted, is set to read-only, or is not writable. The script exits with distinct error codes for each condition.

## Usage
To use FSTest, simply run the script with the path to the filesystem as the argument. For example:
```bash
sudo ./fstest.sh /mnt/myfilesystem

