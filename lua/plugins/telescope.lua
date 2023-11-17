return {
  {
    "nvim-telescope/telescope.nvim",

    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
    },
    keys = {
      { "<leader>,",  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer", },
      { "<leader>:",  "<cmd>Telescope command_history<cr>",                          desc = "Command History" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                               desc = "Find Files (root dir)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                 desc = "Recent" },
      { "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<cr>",          desc = "Colorscheme with preview" },

      { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>",                      desc = "Document diagnostics" },
      { "<leader>lw", "<cmd>Telescope diagnostics<cr>",                              desc = "Workspace diagnostics" },

      { "<leader>gc", "<cmd>Telescope git_commits<CR>",                              desc = "commits" },
      { "<leader>go", "<cmd>Telescope git_status<CR>",                               desc = "status" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>",                             desc = "status" },

      { "<leader>sf", "<cmd>Telescope find_files<cr>",                               desc = "Find Files (root dir)" },
      { "<leader>st", "<cmd>Telescope live_grep<cr>",                                desc = "Grep" },
      { '<leader>s"', "<cmd>Telescope registers<cr>",                                desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>",                             desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>",                          desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>",                                 desc = "Commands" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>",                               desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                  desc = "Key Maps" },

      { "<leader>sM", "<cmd>Telescope man_pages<cr>",                                desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",                                    desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>",                              desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>",                                   desc = "Resume" },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end

      return {
        pickers = {
          find_files = {
            hidden = true
          }
        },
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())

            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = {
      open_cmd = "noswapfile vnew",
      mapping = {
        ['send_to_qf'] = {
          map = "<C-q>",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix"
        },
      }

    },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  }

}
