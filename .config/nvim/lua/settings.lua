local settings = {
	termguicolors = true,
	mouse = "a",
	errorbells = true,
	hidden = true,
	fileencoding = "utf-8",
	clipboard = "unnamedplus",
	wildignorecase = true,
	wildignore = ".git/**,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**";
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
	timeoutlen = 500,
	updatetime = 500,
	-- redrawtime = 100,
	ignorecase = true,
	smartcase = true,
	wrap = false,
	number = true,
	showmode = false,
	completeopt = "menuone,noselect",
	background = "dark",
	shadafile = "NONE",
}

for name, value in pairs(settings) do
	vim.o[name] = value
end

vim.opt.shortmess:append("asI")
vim.cmd("let &fcs='eob: '")

local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
