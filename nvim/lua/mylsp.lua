-- lsp install --
local _, lspinstall = pcall(require, "nvim-lsp-installer")

lspinstall.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})

local servers = {
  "pyright",
  "clangd",
  "texlab",
}

for _, name in pairs(servers) do
  local server_is_found, server = lspinstall.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Downloading " .. name)
    server:install()
  end
end

-- lsp configs --
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
end

local lsp_flags = {
    debounce_text_changes = 150,
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local _, lspconfig = pcall(require, "lspconfig")

local servers = {'clangd', 'texlab', 'pyright'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    }
end
