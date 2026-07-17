return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "clang-format",
        "cmakelang",
        "cmakelint",
        "hadolint",
        "isort",
        "markdownlint-cli2",
        "markdown-toc",
        "ocamlformat",
        "prettier",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmake_format" },
        markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ocaml = { "ocamlformat" },
        python = { "ruff_format", "isort", "black" },
        rust = { "rustfmt" },
        zig = { "zigfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
        dockerfile = { "hadolint" },
        markdown = { "markdownlint-cli2" },
        python = { "ruff" },
      },
    },
  },
}
