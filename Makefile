# RealQuick Makefile
# Installation script for Linux systems

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
CONFIG_DIR = $(HOME)/.config/realquick
SCRIPT_DIR = $(HOME)/.local/share/realquick

# Core executables
SCRIPTS = real-quick process-snippet get-input date.sh
UTILITIES = list.sh cb2inp.sh geoCodes.sh
MANAGER = realquick-manager

# Data files
CONFIG_FILE = functions.json
UI_FILE = realquick-manager.ui

.PHONY: all install install-user install-system uninstall uninstall-user uninstall-system clean help

all: help

help:
	@echo "RealQuick Installation"
	@echo "======================"
	@echo ""
	@echo "Available targets:"
	@echo "  make install-user    - Install for current user (recommended)"
	@echo "  make install-system  - Install system-wide (requires sudo)"
	@echo "  make uninstall-user  - Remove user installation"
	@echo "  make uninstall-system- Remove system installation"
	@echo "  make clean           - Clean build artifacts"
	@echo ""
	@echo "After installation:"
	@echo "  - Run 'real-quick' or bind it to a hotkey"
	@echo "  - Run 'realquick-manager' to manage functions and snippets"
	@echo "  - Config stored in: $(CONFIG_DIR)"
	@echo ""

install: install-user

install-user:
	@echo "Installing RealQuick for current user..."
	@# Create directories
	@mkdir -p $(CONFIG_DIR)
	@mkdir -p $(CONFIG_DIR)/snips
	@mkdir -p $(CONFIG_DIR)/inps
	@mkdir -p $(CONFIG_DIR)/themes
	@# Install all scripts to config directory
	@install -m 755 real-quick $(CONFIG_DIR)/real-quick
	@install -m 755 realquick-manager $(CONFIG_DIR)/realquick-manager
	@install -m 755 process-snippet $(CONFIG_DIR)/process-snippet
	@install -m 755 get-input $(CONFIG_DIR)/get-input
	@install -m 755 date.sh $(CONFIG_DIR)/date.sh
	@install -m 755 list.sh $(CONFIG_DIR)/list.sh
	@install -m 755 cb2inp.sh $(CONFIG_DIR)/cb2inp.sh
	@install -m 755 geoCodes.sh $(CONFIG_DIR)/geoCodes.sh
	@# Copy UI file
	@install -m 644 realquick-manager.ui $(CONFIG_DIR)/realquick-manager.ui
	@# Copy example config if it doesn't exist
	@if [ ! -f $(CONFIG_DIR)/functions.json ]; then \
		install -m 644 functions.json $(CONFIG_DIR)/functions.json; \
		echo "Installed example functions.json"; \
	else \
		echo "Existing functions.json preserved"; \
	fi
	@# Copy example snippets (don't overwrite existing)
	@for snip in snips/*; do \
		[ -f "$$snip" ] && cp -n "$$snip" $(CONFIG_DIR)/snips/ 2>/dev/null || true; \
	done
	@# Copy themes if they exist
	@if [ -d themes ] && [ "$$(ls -A themes 2>/dev/null)" ]; then \
		for theme in themes/*; do \
			[ -f "$$theme" ] && cp -n "$$theme" $(CONFIG_DIR)/themes/ 2>/dev/null || true; \
		done; \
	fi
	@# Create symlinks in ~/.local/bin
	@mkdir -p $(HOME)/.local/bin
	@ln -sf $(CONFIG_DIR)/real-quick $(HOME)/.local/bin/real-quick
	@ln -sf $(CONFIG_DIR)/realquick-manager $(HOME)/.local/bin/realquick-manager
	@echo ""
	@echo "✓ RealQuick installed successfully!"
	@echo ""
	@echo "Installation location: $(CONFIG_DIR)"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Make sure ~/.local/bin is in your PATH"
	@echo "     Add to ~/.bashrc or ~/.zshrc:"
	@echo "     export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo ""
	@echo "  2. Run 'real-quick' or bind it to a hotkey (e.g., Super+Q)"
	@echo "     - i3wm: bindsym \$$mod+q exec real-quick"
	@echo "     - sway: bindsym \$$mod+q exec real-quick"
	@echo ""
	@echo "  3. Customize your functions: realquick-manager"
	@echo ""

install-system:
	@echo "Installing RealQuick system-wide..."
	@# Create directories
	@mkdir -p $(BINDIR)
	@mkdir -p /usr/local/share/realquick
	@# Install all scripts
	@install -m 755 real-quick $(BINDIR)/real-quick
	@install -m 755 realquick-manager $(BINDIR)/realquick-manager
	@install -m 755 process-snippet /usr/local/share/realquick/process-snippet
	@install -m 755 get-input /usr/local/share/realquick/get-input
	@install -m 755 date.sh /usr/local/share/realquick/date.sh
	@install -m 755 list.sh /usr/local/share/realquick/list.sh
	@install -m 755 cb2inp.sh /usr/local/share/realquick/cb2inp.sh
	@install -m 755 geoCodes.sh /usr/local/share/realquick/geoCodes.sh
	@install -m 644 realquick-manager.ui /usr/local/share/realquick/realquick-manager.ui
	@install -m 644 functions.json /usr/local/share/realquick/functions.json
	@# Copy example snippets
	@mkdir -p /usr/local/share/realquick/snips
	@cp snips/* /usr/local/share/realquick/snips/
	@echo ""
	@echo "✓ RealQuick installed system-wide!"
	@echo ""
	@echo "Users should copy config to their home directory:"
	@echo "  mkdir -p ~/.config/realquick"
	@echo "  cp /usr/local/share/realquick/functions.json ~/.config/realquick/"
	@echo "  cp -r /usr/local/share/realquick/snips ~/.config/realquick/"
	@echo ""

uninstall-user:
	@echo "Uninstalling RealQuick (user installation)..."
	@rm -f $(HOME)/.local/bin/real-quick
	@rm -f $(HOME)/.local/bin/realquick-manager
	@rm -rf $(SCRIPT_DIR)
	@echo "✓ RealQuick uninstalled (config preserved at $(CONFIG_DIR))"
	@echo "  To remove config: rm -rf $(CONFIG_DIR)"

uninstall-system:
	@echo "Uninstalling RealQuick (system installation)..."
	@rm -f $(BINDIR)/real-quick
	@rm -f $(BINDIR)/realquick-manager
	@rm -rf /usr/local/share/realquick
	@echo "✓ RealQuick uninstalled"

clean:
	@echo "Cleaning build artifacts..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@echo "✓ Clean complete"
