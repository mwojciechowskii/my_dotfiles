require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "css", "html", "python", "rust", "bash", "typescript", "javascript", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		additional_vim_regex_highlighting = false,
	},
	-- Incremental selection for better code manipulation
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",      -- Start selection
			node_incremental = "grn",    -- Increment to the next node
			scope_incremental = "grc",   -- Increment to the next scope
			node_decremental = "grm",    -- Decrement to the previous node
		},
	},

	-- Enable indentation based on Treesitter
	indent = {
		enable = true,  -- Note: Indentation support is experimental for some languages
	},
}
