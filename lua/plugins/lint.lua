return {
  "mfussenegger/nvim-lint",

  event = { "BufReadPost", "BufNewFile" },
  opts = {
    events = { "BufReadPost", "BufWritePost", "InsertLeave", "BufNewFile" },
    linters_by_ft = {
      lua = { "luacheck" },
      c = { "cpplint" },
      cpp = { "cpplint" },
      python = { "mypy" },
      go = { "golangcilint" },
      -- rust = { "clippy" },
      -- javascript = { "eslint_d", "eslint" },
      -- typescript = { "eslint_d", "eslint" },
      -- htmlangular = { "eslint_d", "eslint" },
      -- html = { "eslint_d", "eslint" },
    },
  },
  config = function(_, opts)
    require("lint").linters_by_ft = opts.linters_by_ft

    local lint_autogroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd(opts.events, {
      group = lint_autogroup,
      callback = function()
        require("config.utils").debounce(100, function()
          require("lint").try_lint()
        end)()
      end,
    })
  end,
}
