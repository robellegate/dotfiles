#!/usr/bin/env bash

# benchmark_zsh.sh
# A script to benchmark ZSH loading times and profile ZSH initialization.

# Exit immediately if a command exits with a non-zero status,
# treat unset variables as an error, and fail on errors in a pipeline.
set -euo pipefail

# ----------------------------
# Constants
# ----------------------------

# Operating system detection.
readonly OS=$(uname -s)

# Number of iterations for timing
readonly ITERATIONS=10

# Report directory
readonly REPORT_DIR="reports"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Git commit hash (abbreviated)
if command_exists git && $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
  readonly GIT_COMMIT_HASH=$(git rev-parse --short HEAD)
else
  readonly GIT_COMMIT_HASH="no-git"
fi

# Full paths for reports
ZPROF_REPORT="$REPORT_DIR/$(printf "zprof_report_%s.txt" "$GIT_COMMIT_HASH")"
HYPERFINE_RESULTS="$REPORT_DIR/$(printf "hyperfine_results_%s.json" "$GIT_COMMIT_HASH")"

# Commands
TIME_CMD=""
TIME_FORMAT=""

# ----------------------------
# Functions
# ----------------------------

# Function to setup the report directory
setup_report_directory() {
  if [ ! -d "$REPORT_DIR" ]; then
    mkdir -p "$REPORT_DIR"
    echo "Created report directory: $REPORT_DIR"
  else
    echo "Report directory already exists: $REPORT_DIR"
  fi
}

# Function to time ZSH loading using GNU time or shell built-in time
time_zsh_loading() {
  echo "Timing ZSH loading using the appropriate time command..."

  if [ "$OS" = "Darwin" ]; then
    TIME_CMD="gtime"
    TIME_FORMAT="\t%E real,\t%U user,\t%S sys"
    echo "Using gtime for timing."
  elif [ "$OS" = "Linux" ]; then
    TIME_CMD="time"
    TIME_FORMAT="\t%E real,\t%U user,\t%S sys"
    echo "Using time for timing."
  else
    # Fallback to shell built-in time
    TIME_CMD="time"
    TIME_FORMAT=""
    echo "Using shell built-in time for timing."
  fi

  # Run the timing
  for _ in $(seq 1 "$ITERATIONS"); do
    if [ -n "$TIME_FORMAT" ]; then
      $TIME_CMD -f "$TIME_FORMAT" "$SHELL" -i -c "exit"
    else
      # Using shell built-in time
      { time "$SHELL" -i -c "exit"; } 2>&1
    fi
  done
}

# Function to time ZSH loading using Hyperfine
hyperfine_zsh_loading() {
  echo "Timing ZSH loading using Hyperfine..."

  if ! command_exists hyperfine; then
    echo "Error: Hyperfine is not installed. Please install it using your package manager."
    echo "For example, on macOS: brew install hyperfine"
    echo "Or on Debian/Ubuntu: sudo apt install hyperfine"
    echo "Or on Fedora: sudo dnf install hyperfine"
    exit 1
  fi

  hyperfine --warmup 3 --min-runs 10 \
    "$SHELL -i -c 'exit'" \
    --export-json "$HYPERFINE_RESULTS"

  echo "Hyperfine results saved to $HYPERFINE_RESULTS"
}

# Function to profile ZSH initialization using zprof
profile_zsh_initialization() {
  echo "Profiling ZSH initialization using zprof..."

  # Run ZSH with ZPROF=true to enable profiling via ~/.zshrc
  # The zprof output will be saved to zprof_report_<commit_hash>.txt
  ZPROF=true "$SHELL" -i -c 'exit' > "$ZPROF_REPORT"

  # Extract and print the first section of the zprof
  # report (header and main table)
  awk '
    /^-+$/ { count++ }
    count < 2 { print }
    count == 2 { exit }
  ' "$ZPROF_REPORT"

  echo "zprof report saved to $ZPROF_REPORT"
}

# Function to prefix/suffix Git commit hash to reports
integrate_with_git() {
  if [ "$GIT_COMMIT_HASH" = "no-git" ]; then
    echo "Warning: Git is not available. Reports will not include commit hashes."
  else
    echo "Using Git commit hash: $GIT_COMMIT_HASH for report filenames."
  fi
}

# Main benchmarking function
main() {
  echo "Starting ZSH benchmarking..."
  echo "Detected Operating System: $OS"
  echo "Git Commit Hash: $GIT_COMMIT_HASH"
  echo "----------------------------------------"

  # Setup the report directory
  setup_report_directory

  # Integrate with Git for report naming
  integrate_with_git

  # Timing with time command
  echo "Running timing with time command..."
  time_zsh_loading
  echo "----------------------------------------"

  # Timing with Hyperfine
  echo "Running timing with Hyperfine..."
  hyperfine_zsh_loading
  echo "----------------------------------------"

  # Profiling with zprof
  echo "Running profiling with zprof..."
  profile_zsh_initialization
  echo "----------------------------------------"

  echo "Benchmarking complete."
  echo "Reports are available in the '$REPORT_DIR/' directory."
}

# Execute the main function
main
