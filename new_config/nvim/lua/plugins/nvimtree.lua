return {
    {
	"3rd/image.nvim",
	dependencies = {
	    'leafo/magick',
	},
	opts = {
	    backend = "kitty",
	    integrations = {
		markdown = {
		    enabled = true,
		    clear_in_insert_mode = false,
		    download_remote_images = true,
		    only_render_image_at_cursor = false,
		    filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
		},
		neorg = {
		    enabled = true,
		    clear_in_insert_mode = false,
		    download_remote_images = true,
		    only_render_image_at_cursor = false,
		    filetypes = { "norg" },
		},
		html = {
		    enabled = false,
		},
		css = {
		    enabled = false,
		},
	    },
	}
    },
    {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	    "MunifTanjim/nui.nvim",
	    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	keys = {
	{
	    "<leader>fe",
	    function()
		require("neo-tree.command").execute({ toggle = true })
	    end,
	    desc = "Explorer NeoTree (Root Dir)",
	},
	{
	    "<leader>fE",
	    function()
		require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
	    end,
	    desc = "Explorer NeoTree (cwd)",
	},
	{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
	{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
	{
	    "<leader>ge",
	    function()
		require("neo-tree.command").execute({ source = "git_status", toggle = true })
	    end,
	    desc = "Git Explorer",
	},
	{
	    "<leader>be",
	    function()
		require("neo-tree.command").execute({ source = "buffers", toggle = true })
	    end,
	    desc = "Buffer Explorer",
	},
	},
	deactivate = function()
	    vim.cmd([[Neotree close]])
	end,
	init = function()
	    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
	    -- because `cwd` is not set up properly.
	    vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
		desc = "Start Neo-tree with directory",
		once = true,
		callback = function()
		if package.loaded["neo-tree"] then
		    return
		else
		    local stats = vim.uv.fs_stat(vim.fn.argv(0))
		    if stats and stats.type == "directory" then
			require("neo-tree")
		    end
		end
		end,
	    })
	end,
	opts = {
	    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
	    popup_border_style = "rounded",
	    enable_git_status = true,
	    enable_diagnostics = true,
	    sources = { "filesystem", "buffers", "git_status" },
	    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
	    filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
	    },
	    window = {
		position = "right",
		width = 30,
		mappings = {
		    ["l"] = "open",
		    ["h"] = "close_node",
		    ["<space>"] = "none",
		    ["Y"] = {
			function(state)
			    local node = state.tree:get_node()
			    local path = node:get_id()
			    vim.fn.setreg("+", path, "c")
			    end,
			desc = "Copy Path to Clipboard",
		    },
		    ["O"] = {
			function(state)
			    require("lazy.util").open(state.tree:get_node().path, { system = true })
			end,
			desc = "Open with System Application",
		    },
		    ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
		    ["a"] = { 
			"add",
			-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
			-- some commands may take optional config options, see `:h neo-tree-mappings` for details
			config = {
			    show_path = "none" -- "none", "relative", "absolute"
			}
		    },
		    ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
		    ["d"] = "delete",
		    ["r"] = "rename",
		    ["S"] = "open_split",
		    ["s"] = "open_vsplit",
		},
	    },
	    default_component_configs = {
		indent = {
		    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
		    expander_collapsed = "",
		    expander_expanded = "",
		    expander_highlight = "NeoTreeExpander",
		},
		git_status = {
		    symbols = {
			unstaged = "󰄱",
			staged = "󰱒",
		    },
		},
	    },
	},
    },
}

