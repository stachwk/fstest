#!/bin/bash
# fstest.sh - Script to check if a filesystem is mounted, writable, and not read-only
# This file is part of fstest.
# autor stachwk
# fstest is licensed under the GNU General Public License v3.0.
# To view a copy of this license, visit: https://www.gnu.org/licenses/gpl-3.0.html

# Function to check if required tools are available
check_required_tools() {
    local tools=("mountpoint" "findmnt" "blockdev")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Required tool $tool is not installed. Please install it and try again."
            exit 1
        fi
    done
}

# Initialize error code
error_code=0

# Check for required tools
check_required_tools

# Function to check if a filesystem is mounted
is_mounted() {
    mountpoint -q "$1"
}

# Function to check if a filesystem is writable
is_writable() {
    test_file="$1/fstest"
    echo "test" > "$test_file" 2>/dev/null
    if [ -f "$test_file" ]; then
        rm -f "$test_file" # Clean up the test file if it exists
        return 0 # True, it's writable
    else
        return 1 # False, it's not writable or read-only
    fi
}

# Function to check if a filesystem is read-only
is_read_only() {
    if findmnt -no OPTIONS "$1" | grep -qw 'ro'; then
        return 0 # True, it's read-only
    else
        return 1 # False, it's not read-only
    fi
}

# Function to check if the device is in read-only mode
is_device_read_only() {
    local device=$(findmnt -no SOURCE "$1")
    if [ $(blockdev --getro "$device") -eq 1 ]; then
        return 0 # True, device is read-only
    else
        return 1 # False, device is not read-only
    fi
}

# Main script starts here
# Check for argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [path_to_filesystem]"
    error_code=$((error_code + 1))
    exit $error_code
fi

# Filesystem path
FS_PATH=$1

# Check if filesystem is mounted
if is_mounted "$FS_PATH"; then
    echo "Filesystem $FS_PATH is mounted."

    # Check if the device is read-only
    if is_device_read_only "$FS_PATH"; then
        echo "WARNING: Device for $FS_PATH is set to read-only mode."
        error_code=$((error_code + 16))
    fi

    # Check if filesystem is read-only
    if is_read_only "$FS_PATH"; then
        echo "WARNING: Filesystem $FS_PATH is read-only."
        error_code=$((error_code + 8))
    else
        # Check if filesystem is writable
        if is_writable "$FS_PATH"; then
            echo "Filesystem $FS_PATH is writable."
        else
            echo "WARNING: Filesystem $FS_PATH is not writable."
            error_code=$((error_code + 4))
        fi
    fi
else
    echo "WARNING: Filesystem $FS_PATH is not mounted."
    error_code=$((error_code + 2))
fi

# Exit with the error code
exit $error_code

