-- Markdown Preview minimal configuration
vim.g.mkdp_auto_start = 0        -- Don't auto-start, use manual control for testing
vim.g.mkdp_auto_close = 1        -- Auto-close preview when leaving markdown buffer
vim.g.mkdp_refresh_slow = 0      -- Refresh preview on save or leaving insert mode
vim.g.mkdp_browser = ''          -- Use default browser
vim.g.mkdp_echo_preview_url = 1   -- Echo preview URL to help with debugging
vim.g.mkdp_page_title = '「${name}」'
vim.g.mkdp_filetypes = {'markdown'}
vim.g.mkdp_theme = 'dark'

vim.g.mkdp_css = vim.fn.expand("/home/michal/.config/nvim/markdown.css")

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>mp', ':MarkdownPreview<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ms', ':MarkdownPreviewStop<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>mt', ':MarkdownPreviewToggle<CR>', {noremap = true, silent = true})
