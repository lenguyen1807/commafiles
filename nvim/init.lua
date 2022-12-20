require('impatient')

-- settings --
require("settings")

-- plugins install --
require("plugins")

-- lsp set up --
require("mylsp")
require("mycmp")

-- keymap set up --
require("keymap")

-- plugins set up --
require('lualine').setup()

require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
    },
}

require('nvim-autopairs').setup {}

require("gruvbox").setup({
    italic = false,
})
-- vim.cmd("colorscheme gruvbox")

vim.cmd("colorscheme tokyonight-night")

require('Comment').setup()

require("nvim-tree").setup()

vim.cmd ([[
    let g:vimtex_view_method = 'zathura'
    let g:vimtex_compiler_method = 'latexmk'
    let g:vimtex_quickfix_mode=0
]])
