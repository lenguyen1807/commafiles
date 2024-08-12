return {
    {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	init = function(plugin)
	    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
	    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
	    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
	    -- Luckily, the only things that those plugins need are the custom queries, which we make available
	    -- during startup.
	    require("lazy.core.loader").add_to_rtp(plugin)
	    require("nvim-treesitter.query_predicates")
	end,
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	opts_extend = { "ensure_installed" },
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	opts = {
	    highlight = { enable = true },
	    indent = { enable = true },
	    ensure_installed = {
		"bash",
		"c",
		"cpp",
		"cmake",
		"css",
		"diff",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"make",
		"python",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	    },
	    incremental_selection = {
		enable = true,
		keymaps = {
		init_selection = "<C-space>",
		node_incremental = "<C-space>",
		scope_incremental = false,
		node_decremental = "<bs>",
		},
	    },
	    textobjects = {
		move = {
		enable = true,
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
		goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
		goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
		},
	    },
	},
    },

    -- Automatically add closing tags for HTML and JSX
    {
	"windwp/nvim-ts-autotag",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	config = function()
	    require("nvim-treesitter.configs").setup({
		autotag = {
		    enable = true
		}
	    })
	end
    },
}
