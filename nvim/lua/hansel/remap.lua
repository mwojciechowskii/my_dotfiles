vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ew", vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '<leader>q', ':bd!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<leader>q', '<C-\\><C-n>:bd!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', '<C-u>', { noremap = true, silent = true }) 
