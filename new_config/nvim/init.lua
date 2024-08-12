vim.loader.enable()

-- copy from: https://github.com/jdhao/nvim-config/blob/main/init.lua
local core_conf_files = {
    "config/settings.lua",
    "config/lazy.lua"
}

local viml_conf_dir = vim.fn.stdpath("config") .. "/viml_conf"
-- source all the core config files
for _, file_name in ipairs(core_conf_files) do
  if vim.endswith(file_name, 'vim') then
    local path = string.format("%s/%s", viml_conf_dir, file_name)
    local source_cmd = "source " .. path
    vim.cmd(source_cmd)
  else
    local module_name, _ = string.gsub(file_name, "%.lua", "")
    package.loaded[module_name] = nil
    require(module_name)
  end
end

-- set up colorscheme
vim.cmd("colorscheme vscode")
-- vim.cmd("colorscheme catppuccin")

-- open pdf with zathura
vim.cmd("autocmd BufEnter *.pdf !zathura '%'")
