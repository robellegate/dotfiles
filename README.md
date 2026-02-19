# robellegate/dotfiles

Robert Ellegate's dotfiles, managed with [`chezmoi`](https://chezmoi.io) _/shay-mwah/_

Install them with:

```sh
chezmoi init https://github.com/robellegate/dotfiles.git --apply
```

## Prerequisites

### Essential Tools

- `curl` or `wget`
- `git`

### Shell Compatibility

- A compatible shell (`bash`, `zsh`, etc.)

## Chezmoi Installation

### Linux/macOS

Install and apply one-liner:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init https://github.com/robellegate/dotfiles.git --apply
```

Alternatively, install via Homebrew on macOS:

```sh
brew install chezmoi && chezmoi init https://github.com/robellegate/dotfiles.git --apply
```

## Chezmoi Usage

These are the most common `chezmoi` commands:

```sh
chezmoi add ~/.bashrc # Add a file to the Chezmoi repository
chezmoi apply # Apply all changes
chezmoi apply --dry-run # Dry-run apply
chezmoi apply ~/.bashrc # Apply a specific file
chezmoi diff # Show changes
chezmoi edit ~/.bashrc # Edit a file
chezmoi forget ~/.bashrc # Forget a file
chezmoi help [COMMAND] # Show help for a command
```

## Testing

Performance testing of ZSH startup time can be done via the following methods. The benchmark script measures how long
it takes for ZSH to initialize with the current configuration, uses the `zsh/zprof` module to identify and analyze the
performance of individual components during ZSH startup, and creates a detailed report in the `reports` directory,
including summaries printed directly in the terminal for quick insights.

### VSCode

The repository includes several build tasks and debug configurations within the [`.vscode/`](.vscode) directory.

<details>
<summary>To run the tasks:</summary>

1. Run the Default Build Task:

    - Press `Ctrl+Shift+B` (`Cmd+Shift+B` on macOS) to execute the default build tasks, which is set to "Benchmark ZSH".

2. Run Specific Tasks:

    - Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P` on macOS).
    - Type `Run Task` and select the desired task from the list.

</details>

<details>
<summary>To use the debug configurations:</summary>

1. Open the Debug Panel

    - Click on the debug icon in the Activity Bar on the side of the VSCode window or
    press `Ctrl+Shift+D` (`Cmd+Shift+D` on macOS).

2. Select a Debug Configuration

    - From the dropdown menu, choose the desired debug configuration.

3. Start Debugging

    - Click the green play button or press `F5`. The integrated terminal will execute the selected debug configuration.

</details>

### Command Line

To run the tests from the command line, execute the following script:

```sh
./scripts/benchmark-zsh.sh
```
