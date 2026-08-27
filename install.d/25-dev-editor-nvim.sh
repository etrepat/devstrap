#!/usr/bin/env bash

# Neovim (if selected)
devstrap_prompt_editors
if ! devstrap_editor_selected "NeoVim"; then
    return 0
fi

echo "=> Install Neovim..."
yay -S --noconfirm --needed neovim

echo "=> Copying base config..."
[ -d "$HOME/.config/nvim" ] && mv ~/.config/nvim ~/.config/nvim.bak
cp -r "${DEVSTRAP_PATH}/config/nvim" ~/.config/nvim

# LSP servers for the selected languages (best-effort; some require node/ruby/gem)
lsp_pkgs=()
if devstrap_lang_selected "Elixir"; then lsp_pkgs+=(elixirls); fi
if devstrap_lang_selected "Go"; then lsp_pkgs+=(gopls); fi
if devstrap_lang_selected "Java"; then lsp_pkgs+=(jdtls); fi
if devstrap_lang_selected "Node.js"; then lsp_pkgs+=(typescript-language-server); fi
if devstrap_lang_selected "PHP"; then lsp_pkgs+=(intelephense); fi
if devstrap_lang_selected "Python"; then lsp_pkgs+=(pyright); fi
if devstrap_lang_selected "Ruby"; then lsp_pkgs+=(solargraph); fi
if devstrap_lang_selected "Rust"; then lsp_pkgs+=(rust-analyzer); fi

if (( ${#lsp_pkgs[@]} > 0 )); then
    echo "=> Bootstrapping plugins (lazy.nvim)..."
    nvim --headless "+Lazy! sync" +qa || echo "  (warning: lazy sync failed)"
    echo "=> Installing LSP servers via mason..."
    nvim --headless "+MasonInstall ${lsp_pkgs[*]}" +qa || echo "  (warning: some LSP servers need node/ruby/gem)"
fi