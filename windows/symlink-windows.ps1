# Adds symlink for .gitaliases in homepath
New-Item -Path $env:HOMEPATH\.gitaliases -ItemType SymbolicLink -Value ..\prefs\git\.gitaliases

# Adds symlink for .gitignore_global in homepath
New-Item -Path $env:HOMEPATH\.gitignore_global -ItemType SymbolicLink -Value ..\prefs\git\.gitignore_global

# Adds symlink for \bin in homepath
New-Item -Path $env:HOMEPATH\bin -ItemType SymbolicLink -Value .\bin

# Adds symlinks for vscode config files in homepath
New-Item -Path $env:APPDATA\Code\User\settings.json -ItemType SymbolicLink -Value ..\prefs\visual-studio-code\settings.json -Force
New-Item -Path $env:APPDATA\Code\User\keybindings.json -ItemType SymbolicLink -Value ..\prefs\visual-studio-code\keybindings.json -Force
