#! /usr/bin/env bash
# upgrade_fedora
# Ensures all packages are up-to-date, downloads next major Fedora Linux release, and installs it.

echo "pass"

# Get number of available updates from background service cache file
DNF_UPDATE_COUNT_CACHE_FILE=\"$HOME/.cache/dnf_update_count\"
DNF_SYSTEM_UPDATE_FLAG_FILE=\"$HOME/.cache/dnf_update_flag\"


if [[ -f \"$DNF_UPDATE_COUNT_CACHE_FILE\" ]]; then
    DNF_UPDATES=$(cat \"$DNF_UPDATE_COUNT_CACHE_FILE\")
else
    DNF_UPDATES=0
fi

# Function to retrieve current Fedora release version
get_fedora_release() {
    local release
    release=$(grep -oP 'Fedora release [0-9]+' /etc/fedora-release | awk '{print $3}')
    echo "$release"
}

# Function to install DNF updates
run_dnf_update(num_updates) {
    if [[ $num_updates -gt 0 ]]; then
        echo "Installing $num_updates DNF updates..."
        sudo dnf upgrade --refresh -y

        # create a flag file to indicate that the system has been updated
        if [[ ! -f "$DNF_SYSTEM_UPDATE_FLAG_FILE" ]]; then
            touch "$DNF_SYSTEM_UPDATE_FLAG_FILE"
        fi
        if [[ $? -eq 0 ]]; then
            echo "DNF updates installed successfully."
        else
            echo "Error: Failed to install DNF updates."
            exit 1
        fi
    else
        echo "No DNF updates available."
    fi
}

# Function to download the next major Fedora release
download_next_fedora_release() {
    echo "Downloading next major Fedora release..."
    sudo dnf system-upgrade download --releasever=$(($(get_fedora_release) + 1)) -y --allowerasing
}
