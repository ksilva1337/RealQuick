# Installation Fix - Wrapper Scripts

## The Problem
When installing to `/usr/local/bin`, the scripts couldn't find `functions.json` because they were looking in `/usr/local/bin/` instead of `~/.config/realquick/`.

## The Solution
Create wrapper scripts in `/usr/local/bin` that:
1. Set `REALQUICK_HOME` to point to user's config directory
2. Add helper scripts to PATH
3. Execute the actual scripts from `/usr/local/share/realquick/`

## New Installation Layout

```
/usr/local/bin/
├── real-quick          → Wrapper that sets REALQUICK_HOME and calls actual script
└── realquick-manager   → Wrapper that sets REALQUICK_HOME and calls actual script

/usr/local/share/realquick/
├── real-quick          → Actual main script
├── realquick-manager   → Actual GUI manager
├── process-snippet     → Helper script
├── get-input           → Helper script
├── date.sh             → Helper script
├── list.sh             → Helper script
├── cb2inp.sh           → Helper script
├── geoCodes.sh         → Helper script
├── realquick-manager.ui
├── functions.json.example
├── snips/              → Example snippets
└── themes/             → Rofi themes (if any)

~/.config/realquick/
├── functions.json      → User's function definitions
├── snips/              → User's custom snippets
├── inps/               → Temporary input storage (0-9)
└── themes/             → User's rofi themes
```

## How It Works

### Wrapper Script (/usr/local/bin/real-quick):
```bash
#!/bin/bash
export REALQUICK_HOME="$HOME/.config/realquick"
export PATH="/usr/local/share/realquick:$PATH"
exec /usr/local/share/realquick/real-quick "$@"
```

### Actual Script Detects REALQUICK_HOME:
```bash
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
DPATH="${REALQUICK_HOME:-$SCRIPT_DIR}"  # Uses REALQUICK_HOME if set!
JSON_FILE="$DPATH/functions.json"
```

## Installation Commands

```bash
cd RealQuick
sudo make install
```

This will:
1. ✅ Install actual scripts to `/usr/local/share/realquick/`
2. ✅ Create wrapper scripts in `/usr/local/bin/`
3. ✅ Create user config at `~/.config/realquick/`
4. ✅ Copy example snippets to user config
5. ✅ Ready to use immediately - no PATH modifications needed!

## Testing

After installation:

```bash
# Check wrapper exists
cat /usr/local/bin/real-quick

# Should output:
#!/bin/bash
export REALQUICK_HOME="$HOME/.config/realquick"
export PATH="/usr/local/share/realquick:$PATH"
exec /usr/local/share/realquick/real-quick "$@"

# Test it works
real-quick  # Should open rofi menu
```

## Multi-User Support

Each user automatically gets their own config:
- User A: `~alice/.config/realquick/`
- User B: `~bob/.config/realquick/`

The wrapper ensures `REALQUICK_HOME` points to the correct user's config directory.

## Uninstallation

```bash
sudo make uninstall
```

Removes everything from `/usr/local/` but preserves user configs at `~/.config/realquick/`.
