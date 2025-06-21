vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ew", vim.cmd.Ex)
map('n', '<leader>q', ':bd!<CR>', opts)
map('t', '<leader>q', '<C-\\><C-n>:bd!<CR>', opts)
map('n', '<C-s>', '<C-u>', opts)

map('n', '<leader>ww', ':bnext<CR>', opts)
map('n', '<leader>ee', ':bprevious<CR>', opts)
map("n", "<leader>bb", ":badd %<CR>", opts)
map('n', '<leader>bd', ':bdelete<CR>', opts)

map('n', '<leader>bl', ':ls<CR>', opts)
map('n', '<leader>cd', 'ggVG"+y', opts)
