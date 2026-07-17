return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    opts = {},
    init = function()
      vim.o.autoread = true
    end,
    keys = {
      {
        "<leader>oa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Ask Opencode",
      },
      {
        "<leader>oo",
        function()
          require("opencode").toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle Opencode",
      },
      {
        "<leader>oe",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Opencode Actions",
      },
    },
  },
}
