#!/usr/bin/env bash

# Mise for managing multiple versions of languages
# https://mise.jdx.dev/
echo "=> Installing mise..."
if ! command -v mise &>/dev/null; then
    yay -S --noconfirm --needed mise
else
    echo "=> Seems to be already present, skipping..."
fi

# Agentic toolset (installed & versioned via mise)
echo "=> Installing agentic tools (claude, opencode, herdr) via mise..."
mise use -g usage claude opencode herdr || echo "  (warning: agentic tools install failed — retry with 'mise install claude opencode herdr')"
