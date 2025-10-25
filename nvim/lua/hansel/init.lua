require("hansel.remap")
-- This is just a shortcut that allows us to use `o` as an alias for `vim.opt`
local o = vim.opt

o.compatible = false
o.number = true
o.cmdheight = 2
o.scrolloff = 8
o.hlsearch = false
o.incsearch = true
o.relativenumber = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.modeline = false
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
})
vim.g.transparent_enabled = true
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.keymap.set('n', '<leader>tt', '<cmd>TransparentToggle<CR>', { noremap = true, silent = true })
vim.opt.showmode = false
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})

