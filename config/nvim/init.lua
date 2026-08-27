-- DevStrap base Neovim config
-- Lean-but-useful: lazy.nvim, Catppuccin (default) / Tokyo Night, Treesitter, Telescope, NvimTree,
-- Gitsigns, EditorConfig and LSP (mason) for the languages selected at install time.
-- Switch theme by editing the colorscheme below: "catppuccin-mocha" or "tokyonight-night".

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")

require("lazy").setup("plugins", {
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { "catppuccin-mocha" } },
})

vim.cmd.colorscheme("catppuccin-mocha")