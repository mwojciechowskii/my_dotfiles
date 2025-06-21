-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use "nvim-lua/plenary.nvim"
	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { {"nvim-lua/plenary.nvim"} }
	}

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = {'marko-cerovac/material.nvim'}
	}
	use {
		'marko-cerovac/material.nvim',
		config = function()
			vim.g.material_style = "deep ocean"
			require('material').setup({
				contrast = {
					terminal = false,
					sidebars = false,
					floating_windows = false,
					cursor_line = false,
				},
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
				plugins = {
					"nvim-tree",
					"telescope",
					"nvim-cmp",
				},
			})
			vim.cmd('colorscheme material')
		end
	}
	use {
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				groups = {
					"Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
					"Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
					"Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText",
					"SignColumn", "CursorLine", "CursorLineNr", "StatusLine", "StatusLineNC",
					"EndOfBuffer",
				},
				extra_groups = {},
				exclude_groups = {},
			})
		end
	}

	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	})

	use({
		"iamcco/markdown-preview.nvim",
		run = function() vim.fn["mkdp#util#install"]() end,
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" }
	})
	use('mbbill/undotree')
	use('mfussenegger/nvim-dap')
	use('theHamsta/nvim-dap-virtual-text')
	use('rcarriga/nvim-dap-ui')
	use {
		'jay-babu/mason-nvim-dap.nvim',
		requires = {'williamboman/mason.nvim', 'mfussenegger/nvim-dap'},
	}
	use {
		'dlyongemallo/valgrind.nvim',
		requires = 'mfussenegger/nvim-dap',
	}
	use('nvim-neotest/nvim-nio')
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
		}
	}
	use({ "mfussenegger/nvim-jdtls" })
	use({'CRAG666/code_runner.nvim'})
	use({
		'windwp/nvim-autopairs',
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end
	})
end)


