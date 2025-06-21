local lsp_zero = require('lsp-zero')
local mason   = require('mason')
local mlc     = require('mason-lspconfig')

-- 1. ensure mason and mason-lspconfig are set up and servers installed
mason.setup()
mlc.setup({
  ensure_installed = {
    'lua_ls', 'bashls', 'pyright', 'clangd',
    'html', 'cssls', 'ts_ls', 'emmet_language_server', 'jsonls'
  }
})

-- 2. on_attach + keymaps
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

-- 3. extend lsp-zero defaults
lsp_zero.extend_lspconfig({
  sign_text    = true,
  lsp_attach   = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- 4. shared cfg for individual servers
local cfg = {
  on_attach    = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- 5. Lua LSP
require('lspconfig').lua_ls.setup(vim.tbl_deep_extend("force", cfg, {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
      diagnostics = { globals = { 'vim' } },
      workspace   = {
        library = {
          vim.fn.stdpath('config') .. '/lua',
          vim.fn.stdpath('data')   .. '/site/pack/packer/start/*/lua',
        },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}))

-- 6. other servers
require('lspconfig').bashls.setup(cfg)
require('lspconfig').pyright.setup(cfg)
require('lspconfig').clangd.setup(cfg)
require('lspconfig').html.setup(vim.tbl_deep_extend("force", cfg, {
  filetypes = { 'html', 'markdown' },
  settings = {
    html = {
      validate = { scripts = true, styles = true },
      format   = { enable = true },
    },
  },
}))
require('lspconfig').cssls.setup(vim.tbl_deep_extend("force", cfg, {
  filetypes = { 'css','scss','less','html' },
}))
require('lspconfig').ts_ls.setup(vim.tbl_deep_extend("force", cfg, {
  filetypes = {
    'javascript','javascriptreact','typescript','typescriptreact','html'
  },
}))
require('lspconfig').emmet_language_server.setup(vim.tbl_deep_extend("force", cfg, {
  filetypes = {
    "markdown","html","css","javascriptreact","typescriptreact",
    "scss","sass","less","eruby","pug"
  },
  init_options = {
    showExpandedAbbreviation    = "always",
    showAbbreviationSuggestions = true,
  },
}))
require('lspconfig').jsonls.setup(vim.tbl_deep_extend("force", cfg, {
  filetypes = { 'json', 'jsonc', 'mcmeta', 'fabric.mod.json' },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "fabric.mod.json" },
          url = "https://json.schemastore.org/fabric.mod.json"
        }
      }
    }
  }
}))

-- 7. emmet keybind
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

-- 8. preserve original cmp setup verbatim
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
    ['<Tab>']     = cmp.mapping.confirm({ select = true }),  -- Tab akceptuje sugestię
    ['<C-Space>'] = cmp.mapping.complete(),                  -- Ctrl + Spacja otwiera sugestie
    ['<Esc>']     = cmp.mapping.close(),                     -- Esc zamyka menu sugestii
    ['<CR>']      = cmp.mapping.confirm({ select = false }), -- Enter akceptuje tylko zaznaczoną sugestię
  }),
})

-- 9. finalize
lsp_zero.setup()
