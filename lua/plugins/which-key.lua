return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      ["<leader>"] = {
        ["f"] = {
          name = "Find"
        },
        ["d"] = {
          "Debug"
        },
        ["b"] = {
          name = "Buffers"
        },
        ["g"] = {
          name = "Git"
        },
        ["l"] = {
          name = "LSP"
        },
        ["s"] = {
          name = "Search"
        },
        ["t"] = {
          name = "Toggle"
        },
      }
    })
  end
}
