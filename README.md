# RealQuick

A hotkey-driven launcher for managing and executing frequently-used commands, SQL scripts, and text snippets. Built for Linux systems with rofi integration.

## Features

- **Instant Access**: Bind to a hotkey for lightning-fast command execution
- **Dynamic Input**: Prompt for user input when needed
- **Template System**: Use placeholders (`~0~` through `~9~`) in snippets
- **GUI Manager**: Visual editor for functions and snippets
- **Clipboard Integration**: Results automatically copied to clipboard
- **Customizable**: JSON-based configuration, easily extensible
- **Portable**: All scripts and data in one location

## How It Works

1. Press your configured hotkey
2. Rofi displays searchable list of functions
3. Select a function (optionally provide input via dialog)
4. Commands execute sequentially
5. Result copied to clipboard

Perfect for:
- Database queries and administration
- Git commands with templated messages
- System administration tasks
- Any repetitive text-based workflow

## Installation

### Prerequisites

**Required:**
- Linux (tested on Arch and Kali/Debian)
- [rofi](https://github.com/davatorium/rofi) - Application launcher
- `jq` - JSON processor
- `wl-clipboard` (Wayland) or `xclip` (X11) - Clipboard management

**Optional:**
- Python 3.8+ and PyQt5 - For GUI manager
- `zenity` - For date picker dialog

**Install dependencies (Arch Linux):**
```bash
sudo pacman -S rofi jq wl-clipboard python-pyqt5 zenity
```

**Install dependencies (Debian/Ubuntu/Kali):**
```bash
sudo apt install rofi jq wl-clipboard python3-pyqt5 zenity xclip
```

### Install RealQuick

```bash
git clone https://github.com/ksilva1337/RealQuick.git
cd RealQuick
sudo make install
```

That's it! Executables are installed to `/usr/local/bin` (already in PATH) and your personal config is created at `~/.config/realquick`.

### Set Up Hotkey

**i3wm** - Add to `~/.config/i3/config`:
```
bindsym $mod+q exec real-quick
```

**sway** - Add to `~/.config/sway/config`:
```
bindsym $mod+q exec real-quick
```

**KDE Plasma**:
1. System Settings → Shortcuts → Custom Shortcuts
2. New → Global Shortcut → Command/URL
3. Command: `real-quick`
4. Set trigger (e.g., Meta+Q)

**GNOME**:
1. Settings → Keyboard → Custom Shortcuts
2. Add new shortcut
3. Command: `real-quick`
4. Set keybinding

## Quick Start

### Running Commands

```bash
# Launch the menu
real-quick

# Or bind to a hotkey and use that
```

### Managing Functions and Snippets

```bash
# Launch the GUI manager
realquick-manager
```

The GUI allows you to:
- Create/edit/delete functions
- Manage SQL/text snippets
- Reorder command sequences
- Search functions and snippets

## Configuration

### Directory Structure

```
~/.config/realquick/
├── functions.json          # Function definitions
├── real-quick              # Main launcher
├── realquick-manager       # GUI manager
├── process-snippet         # Snippet processor
├── get-input              # Input dialog handler
├── date.sh                # Date picker
├── snips/                 # Snippet templates
│   ├── example-simple-select
│   ├── example-update-config
│   └── ...
├── inps/                  # Temporary input storage (0-9)
└── themes/                # rofi themes (optional)
```

### functions.json Format

```json
{
    "Function Name": [
        "sh get-input \"Prompt Text\" 0",
        "sh process-snippet snippet-name"
    ]
}
```

### Snippet Placeholders

Snippets support placeholders `~0~` through `~9~` that are replaced with user input:

**Example snippet** (`snips/user-query`):
```sql
SELECT * FROM users WHERE id = ~0~;
```

**Usage:**
1. Function prompts: "Enter User ID"
2. You enter: `42`
3. Result copied to clipboard: `SELECT * FROM users WHERE id = 42;`

## Command Types

### Basic Commands

| Command | Description | Example |
|---------|-------------|---------|
| `sh process-snippet <name>` | Process and copy snippet | `sh process-snippet example-select` |
| `sh get-input "<prompt>" <N>` | Prompt for input, save to inps/N | `sh get-input "User ID" 0` |
| `sh date.sh <N>` | Show date picker, save to inps/N | `sh date.sh 0` |

### Command Chains

Commands execute sequentially. Inputs are saved and referenced by snippets:

```json
{
    "Update User Email": [
        "sh get-input \"User ID\" 0",
        "sh get-input \"New Email\" 1",
        "sh process-snippet update-email"
    ]
}
```

Snippet `update-email`:
```sql
UPDATE users SET email = '~1~' WHERE id = ~0~;
```

## Examples

### Simple Database Query
```json
{
    "Find User by ID": [
        "sh get-input \"User ID\" 0",
        "sh process-snippet find-user"
    ]
}
```

Snippet `snips/find-user`:
```sql
SELECT * FROM users WHERE id = ~0~;
```

### Multi-Input Command
```json
{
    "Date Range Report": [
        "sh date.sh 0",
        "sh date.sh 1",
        "sh process-snippet date-report"
    ]
}
```

Snippet `snips/date-report`:
```sql
SELECT * FROM orders
WHERE created_date BETWEEN '~0~' AND '~1~'
ORDER BY created_date DESC;
```

### System Administration
```json
{
    "Check Service Status": [
        "sh get-input \"Service Name\" 0",
        "sh process-snippet service-status"
    ]
}
```

Snippet `snips/service-status`:
```bash
systemctl status ~0~
```

### Git Workflow
```json
{
    "Commit with Message": [
        "sh get-input \"Commit Type (feat/fix/docs)\" 0",
        "sh get-input \"Description\" 1",
        "sh process-snippet git-commit"
    ]
}
```

Snippet `snips/git-commit`:
```bash
git commit -m "~0~: ~1~"
```

## GUI Manager (realquick-manager)

The PyQt5-based manager provides a visual interface for managing your configuration.

### Features
- **Function List**: Search and browse all functions
- **Command Editor**: Add, remove, reorder commands
- **Snippet Editor**: Create and edit snippets with syntax highlighting
- **Quick Actions**: Buttons for common operations
- **Keyboard Shortcuts**: Ctrl+Alt+0-9 to insert placeholders

### Quick Actions
- **Add QW**: Add a snippet processing command
- **Add Inp**: Add an input prompt command
- **Add Date**: Add a date picker command
- **Add Other**: Add a custom command
- **Move Up/Down**: Reorder commands in sequence

## Advanced Usage

### Using Lists

The `list.sh` script can provide selectable lists:

```json
{
    "Select Environment": [
        "sh list.sh EnvironmentList 0",
        "sh process-snippet deploy-script"
    ]
}
```

Create `EnvironmentList` file with options (one per line).

### Custom Scripts

You can call any script or command:

```json
{
    "Custom Task": [
        "sh get-input \"Parameter\" 0",
        "python3 /path/to/custom_script.py",
        "sh process-snippet result-template"
    ]
}
```

### Chaining Commands

Commands run sequentially. Use this for complex workflows:

```json
{
    "Database Backup and Upload": [
        "sh get-input \"Database Name\" 0",
        "sh process-snippet backup-command",
        "sh get-input \"Remote Server\" 1",
        "sh process-snippet upload-command"
    ]
}
```

## Troubleshooting

### rofi doesn't appear
- Check if rofi is installed: `which rofi`
- Test rofi manually: `echo "test" | rofi -dmenu`
- Check your hotkey configuration

### Snippets not copied to clipboard
- Wayland: Ensure `wl-clipboard` is installed
- X11: Install `xclip` and modify `process-snippet` to use `xclip` instead of `wl-copy`

### GUI manager won't start
- Check Python version: `python3 --version` (need 3.8+)
- Install PyQt5: `pip install PyQt5` or use system package
- Run from terminal to see errors: `realquick-manager`

### PATH issues
- Verify `~/.local/bin` in PATH: `echo $PATH`
- Add to shell config: `export PATH="$HOME/.local/bin:$PATH"`
- Restart shell or run: `source ~/.bashrc`

### Permission denied
- Ensure scripts are executable: `chmod +x ~/.config/realquick/*`

## Uninstallation

```bash
cd RealQuick
sudo make uninstall
```

To also remove your personal configuration:
```bash
rm -rf ~/.config/realquick
```

## Contributing

Contributions welcome! This project is designed to be simple and extensible.

Areas for improvement:
- Additional input types (file picker, number spinner, etc.)
- More example snippets
- Theme support for rofi
- Packaging for various distros

## License

This project is released into the public domain. Use it however you like!

## Credits

Created as a productivity tool for managing SQL queries and system administration tasks.

Built with:
- [rofi](https://github.com/davatorium/rofi) - Application launcher
- [PyQt5](https://www.riverbankcomputing.com/software/pyqt/) - GUI framework
- Shell scripting and love for efficiency
