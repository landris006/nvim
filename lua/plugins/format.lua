return {
  "stevearc/conform.nvim",

  event = { "BufReadPost", "BufNewFile" },
  opts = {
    formatters = {
      prettier = {
        prepend_args = { "--single-quote", "--trailing-comma", "all" },
      }
    },
    formatters_by_ft = {
      javascript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" } ,
      html = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
      json = { "prettierd", "prettier" },
      yaml = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      lua = { "stylua" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      python = { "black" },
      go = { "goimports", "gofmt", "golines" },
    },
    format_on_save = function()
      if vim.g.autoformat_disable then
        return
      end

      return {
        lsp_fallback = true,
        async = false,
        timeout_ms = 2000,
      }
    end,
  },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 2000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format"
    },
    {
      "<leader>tf",
      function()
        vim.g.autoformat_disable = not vim.g.autoformat_disable
        vim.notify("Autoformat " .. (vim.g.autoformat_disable and "disabled" or "enabled"), vim.log.levels.INFO)
      end,
      mode = { "n" },
      desc = "Toggle autoformat"
    },
  },
}
