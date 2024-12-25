local source_names = {
	nvim_lsp = "(LSP)",
	emoji = "(Emoji)",
	path = "(Path)",
	calc = "(Calc)",
	cmp_tabnine = "(Tabnine)",
	vsnip = "(Snippet)",
	luasnip = "(Snippet)",
	buffer = "(Buffer)",
	tmux = "(TMUX)",
	copilot = "(Copilot)",
	treesitter = "(TreeSitter)",
}
local duplicates = {
	buffer = 1,
	path = 1,
	nvim_lsp = 0,
	luasnip = 1,
}

local function first_to_upper(str)
	return (str:gsub("^%l", string.upper))
end

return {
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
					keyword_length = 0,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered()
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						local max_width = 50
						if max_width ~= 0 and #vim_item.abbr > max_width then
							vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1)
								.. require("config.utils").icons.ui.Ellipsis
						end

						vim_item.kind = (require("config.utils").icons.kind[first_to_upper(vim_item.kind)] or "")
							.. " "
							.. vim_item.kind
						vim_item.menu = source_names[entry.source.name]
						vim_item.dup = duplicates[entry.source.name] or 0
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					-- ["<S-Tab>"] = cmp.mapping(function(fallback)
					--   cmp.mapping.abort()
					--   local copilot_keys = vim.fn["copilot#Accept"]()
					--   if copilot_keys ~= "" then
					--     vim.api.nvim_feedkeys(copilot_keys, "i", true)
					--   else
					--     fallback()
					--   end
					-- end)
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
				sorting = defaults.sorting,
			}
		end,
		---@param opts cmp.ConfigSchema
		config = function(_, opts)
			for _, source in ipairs(opts.sources) do
				source.group_index = source.group_index or 1
			end
			require("cmp").setup(opts)
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		build = (not jit.os:find("Windows"))
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
			or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>tp",
				function()
					vim.g.minipairs_disable = not vim.g.minipairs_disable
					vim.notify(
						"Autopairs " .. (vim.g.minipairs_disable and "disabled" or "enabled"),
						vim.log.levels.INFO
					)
				end,
				desc = "Toggle auto pairs",
			},
		},
	},
}
