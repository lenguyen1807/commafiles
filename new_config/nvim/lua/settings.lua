-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

local settings = {
	termguicolors = true,
	mouse = "a",
	errorbells = true,
	hidden = true,
	fileencoding = "utf-8",
	wildignorecase = true,
	wildignore = ".git/**,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
	backup = false,
	swapfile = false,
	writebackup = false,
	undofile = true,
	history = 1000,
	smarttab = true,
	smartindent = true,
	shiftround = true,
	shiftwidth = 4,
	cmdheight = 1,
	lazyredraw = true,
	timeout = true,
	timeoutlen = 300,
	updatetime = 250,
	-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
	ignorecase = true,
	smartcase = true,
	wrap = true,
	number = true,
	relativenumber = true,
	showmode = false,
	completeopt = "menuone,noselect",
	background = "dark",
	shadafile = "NONE",
	breakindent = true,
	signcolumn = "yes",
	splitright = true,
	splitbelow = true,
	inccommand = "split",
}

for name, value in pairs(settings) do
	vim.o[name] = value
end

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.shortmess:append("asI")
vim.cmd("let &fcs='eob: '")

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
