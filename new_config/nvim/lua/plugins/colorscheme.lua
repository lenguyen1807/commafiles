return {
    -- gruvbox
    {
	"ellisonleao/gruvbox.nvim", 
	lazy = true,
	opts = {
	    contrast = "hard",
	    transparent_mode = true,
	}
    },

    -- vscode
    {
	'Mofiqul/vscode.nvim',
	lazy = true,
	opts = {}
    },

    -- vscode_modern
    {
	"gmr458/vscode_modern_theme.nvim",
	lazy = true,
	config = function()
	    require("vscode_modern").setup({
		cursorline = true,
		transparent_background = false,
		nvim_tree_darker = true,
	    })
	end,
    },

    -- tokyonight
    {
	"folke/tokyonight.nvim",
	lazy = true,
	opts = { style = "moon" },
    },

    -- catppuccin
    {
	"catppuccin/nvim",
	lazy = true,
	name = "catppuccin",
	opts = {
	integrations = {
	    aerial = true,
	    alpha = true,
	    cmp = true,
	    dashboard = true,
	    flash = true,
	    grug_far = true,
	    gitsigns = true,
	    headlines = true,
	    illuminate = true,
	    indent_blankline = { enabled = true },
	    leap = true,
	    lsp_trouble = true,
	    mason = true,
	    markdown = true,
	    mini = true,
	    native_lsp = {
	    enabled = true,
	    underlines = {
		errors = { "undercurl" },
		hints = { "undercurl" },
		warnings = { "undercurl" },
		information = { "undercurl" },
	    },
	    },
	    navic = { enabled = true, custom_bg = "lualine" },
	    neotest = true,
	    neotree = true,
	    noice = true,
	    notify = true,
	    semantic_tokens = true,
	    telescope = true,
	    treesitter = true,
	    treesitter_context = true,
	    which_key = true,
	},
	},
    },
}
