vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<leader>li', "<cmd>LspInfo<cr>", opts)
    vim.keymap.set('n', 'gl', function()
      vim.diagnostic.open_float(nil, { scope = 'line' })
    end, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
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
    opts = {
      automatic_installation = true,
      ensure_installed = { "clangd", "cmake", "rust_analyzer", "jsonls", "yamlls" },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
        ['jsonls'] = function(server_name)
          require('lspconfig')[server_name].setup({
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,
        ['yamlls'] = function(server_name)
          require('lspconfig')[server_name].setup({
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
        ['clangd'] = function()
          require('lspconfig').clangd.setup({
            cmd = {
              "clangd",
              "--offset-encoding=utf-16",
              "--compile-commands-dir=target/debug",
            },
          })
        end,
        ['rust_analyzer'] = function()
          require('lspconfig').rust_analyzer.setup({
            settings = {
              ['rust-analyzer'] = {
                checkOnSave = {
                  allFeatures = true,
                  overrideCommand = {
                    'cargo', 'clippy', '--workspace', '--message-format=json',
                    '--all-targets', '--all-features'
                  }
                }
              }
            }
          })
        end,
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", config = true },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    event = "BufReadPost",
  },
  {
    "github/copilot.vim",

    event = "BufReadPost",
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = "<S-Tab>"
    end
  }
}
