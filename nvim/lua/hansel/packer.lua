-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!
	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { {"nvim-lua/plenary.nvim"} }
	}

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

---	use ({
---		"ellisonleao/gruvbox.nvim",
---		as = 'gruvbox',
---		config = function()
---			vim.cmd('colorscheme gruvbox')
---		end
---	})
---	use {
---		'sainnhe/everforest',
---		config = function()
---			vim.g.everforest_background = 'hard'
---			vim.g.everforest_better_performance = 1
---			vim.cmd('colorscheme everforest')
---		end
---	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = {'marko-cerovac/material.nvim'}
	}
	use {
		'marko-cerovac/material.nvim',
		config = function()
			vim.g.material_style = "deep ocean" -- or "palenight", "oceanic", "darker"
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
      -- Set up transparent.nvim to clear transparency for many default groups
      require("transparent").setup({
        groups = { -- Table: default groups to apply transparency
          "Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
          "Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
          "Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText",
          "SignColumn", "CursorLine", "CursorLineNr", "StatusLine", "StatusLineNC",
          "EndOfBuffer",
        },
        extra_groups = {},   -- Additional groups that should be cleared
        exclude_groups = {}, -- Groups you don't want to clear
      })
    end
  }

		use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'  
	})
	use('mbbill/undotree')
	use({'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'})
	use({'neovim/nvim-lspconfig'})
	use({'hrsh7th/nvim-cmp'})
	use({'hrsh7th/cmp-nvim-lsp'})
	use({'CRAG666/code_runner.nvim'})
end)


