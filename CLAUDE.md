# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RealQuick is a hotkey-driven launcher for managing and executing frequently-used commands, SQL scripts, and text snippets. It integrates with rofi (application launcher) and provides both CLI and GUI (PyQt5) interfaces for managing command workflows.

## Core Architecture

### Execution Flow
1. **real-quick** (main launcher) - reads functions.json, displays rofi menu, executes command sequences
2. **get-input** - prompts user for input via rofi, saves to inps/N files
3. **process-snippet** - reads snippet from snips/, replaces placeholders (~0~-~9~) with input from inps/, copies to clipboard
4. **realquick-manager** - PyQt5 GUI for managing functions and snippets

### Key Design Patterns

**Command Sequencing**: Functions in functions.json contain ordered arrays of commands that execute sequentially. Each command is evaluated in bash within the DPATH directory context.

**Placeholder System**: Snippets use ~N~ placeholders (0-9) which are replaced with content from inps/N files during processing. This enables multi-input workflows.

**Script Directory Resolution**: All scripts use portable symlink resolution to find their directory, then use REALQUICK_HOME environment variable (if set) or fall back to script directory for configuration.

**Clipboard Integration**: process-snippet detects session type (Wayland/X11) and uses appropriate clipboard tool (wl-copy/xclip/xsel).

## Installation Methods

The Makefile supports two installation approaches:

**System Installation** (`make install`):
- Scripts installed to /usr/local/share/realquick/
- Wrapper scripts in /usr/local/bin that set REALQUICK_HOME=$HOME/.config/realquick
- User config auto-created at ~/.config/realquick/

**User Installation** (`make install-user`):
- Everything in ~/.config/realquick/
- Symlinks created in ~/.local/bin/

## Configuration Structure

```
~/.config/realquick/
├── functions.json          # Main configuration
├── snips/                  # Snippet templates
└── inps/                   # Temporary input storage (0-9)
```

## Development Commands

### Installation
```bash
sudo make install          # Install to /usr/local/bin (recommended)
make install-user          # Install to ~/.local/bin
```

### Uninstallation
```bash
sudo make uninstall        # Remove system installation
make uninstall-user        # Remove user installation
```

### Testing
```bash
# Test the launcher directly
./real-quick

# Test with specific function
./real-quick "Look Up User by ID"

# Test snippet processing
./process-snippet example-simple-select

# Test GUI manager
python3 realquick-manager
```

### Debugging
```bash
# View current config
cat ~/.config/realquick/functions.json

# Check what inputs are stored
ls -la ~/.config/realquick/inps/

# Test rofi integration
echo "test" | rofi -dmenu
```

## Important Implementation Details

### Path Resolution
All scripts resolve their directory and use REALQUICK_HOME if set, falling back to script directory. This pattern enables both development and installed usage:
```bash
DPATH="${REALQUICK_HOME:-$SCRIPT_DIR}"
```

### Command Execution Context
Commands in functions.json execute in the DPATH directory via `cd $DPATH && $cmd`. The real-quick script passes last_output between commands for potential chaining.

### GUI Manager Data Flow
- realquick-manager.py loads functions.json and manages it with QStringListModel
- Changes are saved immediately to JSON on each operation (save_func_no_load)
- The manager looks for realquick-manager.ui in its script directory
- SNIPS_DIR is always relative to script directory, not REALQUICK_HOME

### Clipboard Detection
process-snippet checks XDG_SESSION_TYPE to determine Wayland vs X11, falling back through multiple clipboard tools (wl-copy, xclip, xsel).

## Common Patterns

### Adding Input-Based Functions
```json
{
    "Function Name": [
        "sh get-input \"Prompt\" 0",        # Get input, save to inps/0
        "sh process-snippet snippet-name"   # Process snippet with ~0~ placeholder
    ]
}
```

### Multi-Input Workflows
```json
{
    "Complex Task": [
        "sh get-input \"First\" 0",
        "sh get-input \"Second\" 1",
        "sh date.sh 2",
        "sh process-snippet template-with-placeholders"
    ]
}
```

### Quick Function Creation (GUI)
The "Add Func QW" button creates both function and snippet in one operation, generating a random snippet name from the function name.
