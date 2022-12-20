local _, cmp = pcall(require, "cmp")

local _, lspkind = pcall(require, "lspkind")

local context = require("cmp.config.context")

local format = require("lspkind").cmp_format({
    mode = "symbol_text",
    maxwidth = 50,
    presets = "codicons",
})

cmp.setup {
    sources = {
	{name = 'nvim_lsp'},
	{name = 'ultisnips'},
	{name = 'buffer'},
    },

    snippet = {
	expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
    },

    window = {
	completion = {
	    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
	    col_offset = -3,
	    side_padding = 0,
	},
    },

    formatting = {
	fields = { "kind", "abbr", "menu" },
	format = function(entry, vim_item)
	    local kind = format(entry, vim_item)
	    local strings = vim.split(kind.kind, "%s", { trimempty = true })
	    kind.kind = " " .. strings[1] .. " "
	    kind.menu = "    (" .. strings[2] .. ")"
	return kind
	end,
    },

    experimental = {
	ghost_text = true,
    },

    enabled = function()
	if vim.api.nvim_get_mode().mode == "c" then
		return true
	end

	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end

	if vim.api.nvim_buf_get_option(0, "filetype") == "markdown" then
		return false
	end

	return not (
		context.in_treesitter_capture("comment")
		or context.in_syntax_group("Comment")
	)
    end,

    mapping = {
	["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),

	["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),

	["<C-d>"] = cmp.mapping.scroll_docs(4),

	["<C-u>"] = cmp.mapping.scroll_docs(-4),

	['<CR>'] = cmp.mapping.confirm {
	    behavior = cmp.ConfirmBehavior.Insert,
	    select = true,
	},
    }
}

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
        }, {
        { name = 'cmdline' }
    })
})

vim.cmd([[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! link CmpItemKindInterface CmpItemKindVariable
highlight! link CmpItemKindText CmpItemKindVariable
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! link CmpItemKindMethod CmpItemKindFunction
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! link CmpItemKindProperty CmpItemKindKeyword
highlight! link CmpItemKindUnit CmpItemKindKeyword
]])
