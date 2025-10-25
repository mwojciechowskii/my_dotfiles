local lsp_zero = require('lsp-zero')
local mason   = require('mason')
local mlc     = require('mason-lspconfig')

mason.setup()
mlc.setup({
  ensure_installed = {
    'lua_ls', 'bashls', 'pyright', 'clangd',
    'html', 'cssls', 'ts_ls', 'emmet_language_server', 'jsonls'
  }
})

--keymaps
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true, noremap = true }
  vim.keymap.set('n', 'K',  vim.lsp.buf.hover,            opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition,       opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,      opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,   opts)
  vim.keymap.set('n', 'go', vim.lsp.buf.type_definition,  opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references,       opts)
  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help,    opts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename,         opts)
  vim.keymap.set({'n','x'}, '<F3>', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action,    opts)
end

-- extend lsp-zero defaults
lsp_zero.extend_lspconfig({
  sign_text    = true,
  lsp_attach   = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})


-- emmet keybind
vim.keymap.set({'i', 'n'}, '<C-y>,', function()
  vim.lsp.buf.execute_command({
    command   = 'emmet.expand_abbreviation',
    arguments = {
      vim.fn.expand('%:p'),
      vim.fn.line('.'),
      vim.fn.col('.'),
    }
  })
end, { silent = true })


local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>']     = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Esc>']     = cmp.mapping.close(),
    ['<CR>']      = cmp.mapping.confirm({ select = false }),
  }),
})

lsp_zero.setup()
