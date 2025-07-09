vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local builtin = require("telescope.builtin")

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
    vim.keymap.set("n", "gI", builtin.lsp_implementations, {
      buffer = ev.buf,
      desc = "Go to implementation",
    })
    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, {
      buffer = ev.buf,
      desc = "Signature help",
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
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {
      buffer = ev.buf,
      desc = "Rename",
    })
    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, {
      buffer = ev.buf,
      desc = "Code actions",
    })
    vim.keymap.set("n", "gr", builtin.lsp_references, {
      buffer = ev.buf,
      desc = "Find references",
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
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.bo.filetype = "hyprlang"
    vim.lsp.start({
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

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
    opts = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      return {
        automatic_installation = false,
        -- ensure_installed = { "clangd", "cmake", "rust_analyzer", "jsonls", "yamlls", "taplo", "yamlls" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
          ["tailwindcss"] = function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              init_options = {
                userLanguages = {
                  elixir = "html-eex",
                  eelixir = "html-eex",
                  heex = "html-eex",
                },
              },
              root_dir = require("lspconfig.util").root_pattern(
                "tailwind.config.js",
                "tailwind.config.ts",
                "postcss.config.js",
                "postcss.config.ts",
                "package.json",
                "node_modules",
                ".git",
                "mix.exs"
              ),
              -- root_dir = require('lspconfig.util').root_pattern(
              --   "tailwind.config.js",
              --   "tailwind.config.cjs",
              --   "postcss.config.js"
              -- ),
            })
          end,
          ["jsonls"] = function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            })
          end,
          ["yamlls"] = function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              settings = {
                yaml = {
                  hover = true,
                  completion = true,
                  validate = true,
                  schemaStore = {
                    enable = true,
                    url = "https://www.schemastore.org/api/json/catalog.json",
                  },
                  schemas = require("schemastore").yaml.schemas(),
                },
              },
            })
          end,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", config = true },
      "nvim-telescope/telescope.nvim",
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvim-cmp",
    },
    event = "BufReadPost",
    init = function()
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = {
              spacing = 4,
              prefix = "",
            },
            signs = true,
            update_in_insert = false,
          })

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.INFO] = "",
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
        }
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("lspconfig").glsl_analyzer.setup({
        capabilities = capabilities,
      })
      require("lspconfig").wgsl_analyzer.setup({
        capabilities = capabilities,
      })
      require("lspconfig").elixirls.setup({
        capabilities = capabilities,
        cmd = { "elixir-ls" },
      })
      require("lspconfig").html.setup({
        capabilities = capabilities,
        filetypes = { "html", "heex", "eex", "templ" },
      })
      require("lspconfig").clangd.setup({
        capabilities = capabilities,
      })
      require("lspconfig").emmet_ls.setup({
        capabilities = capabilities,
        filetypes = { "html", "css", "elixir", "eelixir", "heex" },
      })
      require("lspconfig").rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = true
          },
        },
      })
      require("lspconfig").nginx_language_server.setup({
        capabilities = capabilities,
      })
      require("lspconfig").qmlls.setup({
        capabilities = capabilities,
        cmd = { "qmlls", "-E" },
      })
      require("lspconfig").hls.setup({
        capabilities = capabilities,
      })
      require("lspconfig").nixd.setup({
        capabilities = capabilities,
        cmd = { "nixd" },
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> {}",
            },
            formatting = {
              command = { "alejandra" },
            },
          },
        },
      })
      require("lspconfig").svelte.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
            callback = function(ctx)
              -- Here use ctx.match instead of ctx.file
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      }
    end,
  },
}
