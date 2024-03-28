local function attached_clients()
  local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
  if #buf_clients == 0 then
    return "LSP Inactive"
  end

  local buf_ft = vim.bo.filetype
  local buf_client_names = {}
  local copilot_active = false

  for _, client in pairs(buf_clients) do
    if client.name ~= "copilot" and client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end

    if client.name == "copilot" then
      copilot_active = true
    end
  end

  local conform = pcall(require, "conform")
  if conform then
    local attached_formatters = require("conform").list_formatters_for_buffer(0)
    vim.list_extend(buf_client_names, attached_formatters)
  end


  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  local unique_client_names = table.concat(buf_client_names, ", ")
  local language_servers = string.format("[%s]", unique_client_names)

  if copilot_active then
    language_servers = language_servers .. "%#SLCopilot#" .. " " .. require('config.utils').icons.git.Octoface .. "%*"
  end

  return language_servers
end

return {
  "hoob3rt/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },

  event = "BufReadPost",
  opts = {
    sections = {
      lualine_c = {
        {
          "filename",
          path = 1,
          color = { gui = "bold" },
        }
      },
      lualine_x = {
        {
          attached_clients,
          color = { gui = "bold" },
        }
      }
    }
  }
}
