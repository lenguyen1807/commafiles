-- get cursor position
local r,c = unpack(vim.api.nvim_win_get_cursor(0))

-- get screen size
local width = vim.api.nvim_get_option("columns")
local height = vim.api.nvim_get_option("lines")

print(width, height)
