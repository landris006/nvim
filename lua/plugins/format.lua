return {
  "stevearc/conform.nvim",

  event = { "BufReadPost", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      lua = { "stylua" },
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
        timeout_ms = 500,
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
          timeout_ms = 500,
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
