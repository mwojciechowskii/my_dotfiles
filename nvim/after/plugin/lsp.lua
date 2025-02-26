--
-- LSP configuration
---
local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
	local opts = {buffer = bufnr}

	vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
	vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
	sign_text = true,
	lsp_attach = lsp_attach,
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- These are just examples. Replace them with the language
-- servers you have installed in your system
require('lspconfig').bashls.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').clangd.setup({})

require('lspconfig').html.setup({
    capabilities = capabilities,
    filetypes = { 'html' }, -- Attach to .html files
    settings = {
        html = {
            validate = {
                -- Enable validation for inline scripts and styles
                scripts = true,
                styles = true,
            },
            -- Optional: Configure formatting options
            format = {
                enable = true,
            },
        },
    },
})

-- CSS Language Server with HTML filetype inclusion for inline styles
require('lspconfig').cssls.setup({
    capabilities = capabilities,
    filetypes = { 'css', 'scss', 'less', 'html' }, -- Attach to CSS and HTML files
    settings = {
        css = {
            validate = true,
        },
        scss = {
            validate = true,
        },
        less = {
            validate = true,
        },
    },
})

-- TypeScript/JavaScript Language Server with HTML filetype inclusion for inline scripts
require('lspconfig').ts_ls.setup({
    capabilities = capabilities,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' }, -- Attach to JS, TS, and HTML files
    settings = {
        javascript = {
            validate = true,
        },
        typescript = {
            validate = true,
        },
    },
})

-- Add this to your lsp.lua or init.lua
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities.textDocument.completion.completionItem.snippetSupport = true

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig').emmet_language_server.setup({
  capabilities = capabilities,
  filetypes = { "html", "css", "javascriptreact", "typescriptreact", "scss", "sass", "less", "eruby", "pug" },
  init_options = {
    showExpandedAbbreviation = "always",
    showAbbreviationSuggestions = true,
  },
})

-- Add these keybindings
--vim.keymap.set({'i', 'n'}, '<C-y>,', function()
--    vim.lsp.buf.execute_command({
--        command = 'emmet.expand_abbreviation',
--        arguments = { vim.fn.expand('%:p'), vim.fn.line('.'), vim.fn.col('.') }
--    })
--end, { silent = true })
---
-- Autocompletion setup
---
local cmp = require('cmp')

cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
	},
	snippet = {
		expand = function(args)
			-- You need Neovim v0.10 to use vim.snippet
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Tab akceptuje sugestię
		['<C-Space>'] = cmp.mapping.complete(),             -- Ctrl + Spacja otwiera sugestie
		['<Esc>'] = cmp.mapping.close(),                    -- Esc zamyka menu sugestii
		['<CR>'] = cmp.mapping.confirm({ select = false }),  -- Enter akceptuje tylko zaznaczoną sugestię

	}),
})
