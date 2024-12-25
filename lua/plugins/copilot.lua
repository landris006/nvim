return {
	{
		"github/copilot.vim",
		event = "BufReadPost",
		enabled = false,
		init = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = "<S-Tab>"
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<S-Tab>",
				},
			})
		end,
	},
}
