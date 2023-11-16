return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true })
      end,
      desc = "Toggle Neotree"
    },
  },
  opts = {
    close_if_last_window = false,
    window = {
      width = 30,
      mappings = {
        ["l"] = "open",
        ["<space>"] = "none",
      }
    },
    buffers = {
      follow_current_file = {
        enabled = true
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = {
        enabled = true
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          "node_modules"
        },

      },
    },
  }
}
