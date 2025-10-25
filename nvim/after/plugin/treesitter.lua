require'nvim-treesitter.configs'.setup {

	ensure_installed = { "json", "css", "html", "java", "cpp", "python", "rust", "bash", "typescript", "javascript", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

	sync_install = false,

	auto_install = true,


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

	indent = {
		enable = true,
	},
}
