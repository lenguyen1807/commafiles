return {
    {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth"
    },
    {
	-- Highlight todo, notes, etc in comments
	'folke/todo-comments.nvim',
	event = 'VimEnter',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = { signs = false }
    },
    { -- Add indentation guides even on blank lines
	'lukas-reineke/indent-blankline.nvim',
	-- Enable `lukas-reineke/indent-blankline.nvim`
	-- See `:help ibl`
	main = 'ibl',
	opts = {},
    },
    { -- Useful plugin to show you pending keybinds.
	'folke/which-key.nvim',
	event = 'VimEnter', -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
	    require('which-key').setup()

	    -- Document existing key chains
	    require('which-key').add {
		{ '<leader>c', group = '[C]ode' },
		{ '<leader>d', group = '[D]ocument' },
		{ '<leader>r', group = '[R]ename' },
		{ '<leader>s', group = '[S]earch' },
		{ '<leader>w', group = '[W]orkspace' },
		{ '<leader>t', group = '[T]oggle' },
		{ '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
	    }
	end,
    },
    { 
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	'lewis6991/gitsigns.nvim',
	opts = {
	    signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '‾' },
		changedelete = { text = '~' },
	    },
	},
    },
    {
	-- Add comment
	"numToStr/Comment.nvim",
	opts = {
	    ---Add a space b/w comment and the line
	    padding = true,
	    ---Whether the cursor should stay at its position
	    sticky = true,
	    ---Lines to be ignored while (un)comment
	    ignore = nil,
	    ---LHS of toggle mappings in NORMAL mode
	    toggler = {
		---Line-comment toggle keymap
		line = 'gcc',
		---Block-comment toggle keymap
		block = 'gbc',
	    },
	    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
	    opleader = {
		---Line-comment keymap
		line = 'gc',
		---Block-comment keymap
		block = 'gb',
	    },
	}
    },
    {
	'windwp/nvim-autopairs',
	event = "InsertEnter",
	config = true,
	-- Optional dependency
	dependencies = { 'hrsh7th/nvim-cmp' },
	-- use opts = {} for passing setup options
	-- this is equalent to setup({}) function
    },
    {
	-- Add syntax highlighting for C++
	"bfrg/vim-cpp-modern"
    },
    {
	-- Fuzzy Finder (files, lsp, etc)
	'nvim-telescope/telescope.nvim',
	event = 'VimEnter',
	branch = '0.1.x',
	dependencies = {
	    'nvim-lua/plenary.nvim',
	    { -- If encountering errors, see telescope-fzf-native README for installation instructions
		'nvim-telescope/telescope-fzf-native.nvim',

		-- `build` is used to run some command when the plugin is installed/updated.
		-- This is only run then, not every time Neovim starts up.
		build = 'make',

		-- `cond` is a condition used to determine whether this plugin should be
		-- installed and loaded.
		cond = function()
		    return vim.fn.executable 'make' == 1
		end,
	    },
	    { 'nvim-telescope/telescope-ui-select.nvim' },
	    -- Useful for getting pretty icons, but requires a Nerd Font.
	    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
	},
	config = function()
	    -- Telescope is a fuzzy finder that comes with a lot of different things that
	    -- it can fuzzy find! It's more than just a "file finder", it can search
	    -- many different aspects of Neovim, your workspace, LSP, and more!
	    --
	    -- The easiest way to use Telescope, is to start by doing something like:
	    --  :Telescope help_tags
	    --
	    -- After running this command, a window will open up and you're able to
	    -- type in the prompt window. You'll see a list of `help_tags` options and
	    -- a corresponding preview of the help.
	    --
	    -- Two important keymaps to use while in Telescope are:
	    --  - Insert mode: <c-/>
	    --  - Normal mode: ?
	    --
	    -- This opens a window that shows you all of the keymaps for the current
	    -- Telescope picker. This is really useful to discover what Telescope can
	    -- do as well as how to actually do it!

	    -- [[ Configure Telescope ]]
	    -- See `:help telescope` and `:help telescope.setup()`
	    require('telescope').setup {
		extensions = {
		    ['ui-select'] = {
			require('telescope.themes').get_dropdown(),
		    },
		},
	    }

	    -- Enable Telescope extensions if they are installed
	    pcall(require('telescope').load_extension, 'fzf')
	    pcall(require('telescope').load_extension, 'ui-select')

	    -- See `:help telescope.builtin`
	    local builtin = require 'telescope.builtin'
	    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
	    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
	    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
	    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
	    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
	    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
	    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
	    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
	end,
    },
    {
	-- Neovim terminal
	'akinsho/toggleterm.nvim',
	version = "*",
	opts = {
	    open_mapping = [[<c-\>]],
	    direction = "tab"
	}
    }
}
