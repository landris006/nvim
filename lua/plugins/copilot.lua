return {
  {
    "github/copilot.vim",
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
  },
  -- {
  -- 	"supermaven-inc/supermaven-nvim",
  -- 	config = function()
  -- 		require("supermaven-nvim").setup({
  -- 			keymaps = {
  -- 				accept_suggestion = "<S-Tab>",
  -- 			},
  -- 		})
  -- 	end,
  -- },
}
