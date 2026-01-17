-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- jk to escape
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Cmd+a select all (macOS)
-- vim.keymap.set({ "n", "i", "v" }, "<D-a>", "<Esc>ggVG", { desc = "Select all" })

-- Option+backspace delete word
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Delete word" })
