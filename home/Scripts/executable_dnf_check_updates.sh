#! /usr/bin/env bash

# dnf_check_updates - Periodically checks DNF for available updates and stores
# the results in a cache file

set -euo pipefail

# Constants
declare -a DEPS=("dnf" "grep")
CACHE_FILE="${CACHE_FILE:-$HOME/.cache/dnf_update_count}"
LOG_FILE="${LOG_FILE:-/tmp/dnf_check_updates.log}"

# Functions

log_message() {
    local message="$1"
    local timestamp

    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

# check_dependencies - Check if the required dependencies are installed
check_dependencies() {
    for dep in "${DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_message "Error: $dep is not installed."
            exit 2
        fi
    done
}

# check_cache - Check if the cache file exists and is writable
check_cache() {
    if [[ ! -f "$CACHE_FILE" ]]; then
        mkdir -p "$(dirname "$CACHE_FILE")"
    fi

    if ! touch "$CACHE_FILE" &> /dev/null; then
        log_message "Error: $CACHE_FILE is not writable."
        exit 3
    fi
}

# fetch_update_count - Fetch the number of available updates from DNF
fetch_update_count() {
    local update_count
    update_count=$(dnf check-update --quiet | grep -c '^[a-zA-Z0-9]')
    echo "$update_count"
}

# write_update_count - Write the update count to the cache file
#
# Arguments:
#   update_count - The number of available updates
write_update_count() {
    local update_count="$1"
    echo "$update_count" > "$CACHE_FILE"
}

# main - The main function of the script
main() {
    check_dependencies
    check_cache

    update_count=$(fetch_update_count)
    write_update_count "$update_count"
    log_message "Update count: $update_count"
}

main
