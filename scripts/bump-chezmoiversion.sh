#!/usr/bin/env bash

set -euo pipefail

# Constants
declare -a DEPS=("git" "rg" "chezmoi")
VERSION_FILE=".chezmoiversion"

# Check if the required dependencies are installed
check_dependencies() {
    for dep in "${DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep is not installed."
            exit 2
        fi
    done
}

# Ensure the script is running in the root directory of the repository
navigate_to_root() {
    local cwd
    local root

    cwd=$(pwd)
    root=$(git rev-parse --show-toplevel)

    if [[ "$cwd" != "$root" ]]; then
        cd "$root" || exit 1
    fi
}

# Fetch and update the Chezmoi version in the repository
update_chezmoi_version() {
    local new_version
    local current_version

    new_version=$(chezmoi --version | rg --pcre2 -o '(?<=version v)\d+\.\d+\.\d')
    if [[ -f "$VERSION_FILE" ]]; then
        current_version=$(cat "$VERSION_FILE")
    else
        current_version="0.0.0"
    fi

    if [[ "$new_version" == "$current_version" ]]; then
        echo "Chezmoi version is up to date."
        exit 0
    else
        echo "Updating Chezmoi version from $current_version to $new_version."
        echo "$new_version" > "$VERSION_FILE"
    fi
}

main() {
    check_dependencies
    navigate_to_root
    update_chezmoi_version
}

main
