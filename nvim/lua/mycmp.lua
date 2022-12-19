local _, cmp = pcall(require, "cmp")

local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    sources = {
	{name = 'nvim_lsp'},
	{name = 'ultisnips'},
	{name = 'buffer'},
    },

    snippet = {
	    expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
    },

    view = {            
	entries = "custom" -- can be "custom", "wildmenu" or "native"
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
	local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
	local strings = vim.split(kind.kind, "%s", { trimempty = true })
	kind.kind = " " .. strings[1] .. " "
	kind.menu = "    (" .. strings[2] .. ")"

	return kind
	end,
    },

    enabled = function()
	local context = require 'cmp.config.context'
	if vim.api.nvim_get_mode().mode == 'c' then
	return true
	else
	return not context.in_treesitter_capture("comment") 
	    and not context.in_syntax_group("Comment")
	end
    end,
  
    mapping = {
	["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),

	["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),

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
