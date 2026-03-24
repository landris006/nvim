return {
	{ "echasnovski/mini.ai", version = "*", config = true },
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
