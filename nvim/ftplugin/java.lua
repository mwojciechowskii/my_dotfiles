local jdtls = require('jdtls')
local home = os.getenv('HOME')
local workspace_dir = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local config = {
  cmd = { 'jdtls', '-data', workspace_dir },
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml'}),
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true, noremap = true }
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover,            opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,       opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,      opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,   opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition,  opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references,       opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help,   opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename,         opts)
    vim.keymap.set({'n','x'}, '<F3>', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action,    opts)
  end,
}

jdtls.start_or_attach(config)
