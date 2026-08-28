#!/usr/bin/env bash

# Agentic toolset (installed & versioned via mise)
echo "=> Installing agentic tools (claude, opencode, herdr) via mise..."
mise use -g usage claude opencode herdr || echo "  (warning: agentic tools install failed — retry with 'mise install claude opencode herdr')"
