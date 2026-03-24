return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "b0o/schemastore.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "nvim-telescope/telescope.nvim",
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", {
            buffer = ev.buf,
            desc = "Show LSP information",
          })
          vim.keymap.set("n", "gl", function()
            vim.diagnostic.open_float(nil, { scope = "line" })
          end, {
            buffer = ev.buf,
            desc = "Open diagnostic float",
          })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = ev.buf,
            desc = "Go to definition",
          })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {
            buffer = ev.buf,
            desc = "Hover",
          })
          vim.keymap.set("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, {
            buffer = ev.buf,
            desc = "Add workspace folder",
          })
          vim.keymap.set("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, {
            buffer = ev.buf,
            desc = "Remove workspace folder",
          })
          vim.keymap.set("n", "<leader>Wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, {
            buffer = ev.buf,
            desc = "List workspace folders",
          })
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, {
            buffer = ev.buf,
            desc = "Go to type definition",
          })
          vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, {
            buffer = ev.buf,
            desc = "Next diagnostic",
          })
          vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, {
            buffer = ev.buf,
            desc = "Prev diagnostic",
          })
        end,
      })

      -- Hyprlang LSP
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.hl", "hypr*.conf" },
        callback = function(_)
          vim.bo.filetype = "hyprlang"
          vim.lsp.start({
            name = "hyprlang",
            cmd = { "hyprls" },
            root_dir = vim.fn.getcwd(),
          })
        end,
      })

      vim.diagnostic.config({
        virtual_lines = true,

        -- virtual_text = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌶",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.ERROR] = "󰅚",
          },
          numhl = {
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
          },
        },
      })

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      require("mason-lspconfig").setup({
        automatic_installation = false,
        handlers = {
          function(server_name)
            vim.lsp.enable(server_name)
          end,
        },
      })

      vim.lsp.enable({
        "wgsl_analyzer",
        "elixirls",
        "gleam",
        "html",
        "clangd",
        "neocmake",
        "ts_ls",
        "emmet_ls",
        "rust_analyzer",
        "nginx_language_server",
        "qmlls",
        "hls",
        "tinymist",
        "nixd",
        "svelte",
        "angularls",
      })
    end,
  },
}
