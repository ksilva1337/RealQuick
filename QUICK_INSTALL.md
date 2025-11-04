# Quick Installation Guide

## For YOU (on your Arch system right now):

```bash
cd /home/work/scripts/RealQuick

# Remove old installation if any
sudo rm -f /usr/local/bin/real-quick /usr/local/bin/realquick-manager
sudo rm -rf /usr/local/share/realquick

# Install with the new fixed Makefile
# Since you can't use sudo interactively, use one of these methods:

# Method 1: If you have sudo NOPASSWD configured
sudo make install

# Method 2: Become root first
sudo -i
cd /home/work/scripts/RealQuick
make install
exit

# Method 3: Use install-user (old method, needs PATH)
make install-user
```

## For OTHERS (the GitHub installation):

```bash
# Install dependencies
# Arch:
sudo pacman -S rofi jq wl-clipboard python-pyqt5 zenity

# Debian/Ubuntu/Kali:
sudo apt install rofi jq wl-clipboard xclip python3-pyqt5 zenity

# Install RealQuick
git clone https://github.com/ksilva1337/RealQuick.git
cd RealQuick
sudo make install
```

That's it! No PATH modifications needed.

## Verify Installation

```bash
# Check the wrapper was created
cat /usr/local/bin/real-quick

# Should see:
#!/bin/bash
export REALQUICK_HOME="$HOME/.config/realquick"
export PATH="/usr/local/share/realquick:$PATH"
exec /usr/local/share/realquick/real-quick "$@"

# Check config was created
ls ~/.config/realquick/

# Should see:
functions.json  inps/  snips/  themes/

# Test it
real-quick  # Opens rofi menu
```

## Troubleshooting

If `real-quick` says "command not found":
- Check `/usr/local/bin` is in PATH: `echo $PATH | grep /usr/local/bin`
- If missing, it should be added by default in `/etc/profile` or similar
- Temporary fix: `export PATH="/usr/local/bin:$PATH"`

If getting "functions.json not found":
- The wrapper script should set `REALQUICK_HOME` automatically
- Check wrapper: `cat /usr/local/bin/real-quick`
- Manually test: `REALQUICK_HOME="$HOME/.config/realquick" /usr/local/share/realquick/real-quick`
