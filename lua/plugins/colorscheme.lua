return {
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "night",
			transparent = false, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim

			styles = {
				comments = { italic = false },
				keywords = { italic = false },
				functions = {},
				variables = {},
				-- Background styles. Can be "dark", "transparent" or "normal"
				-- sidebars = "transparent",       -- style for sidebars, see below
				-- floats = "transparent",         -- style for floating windows
			},
			sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
			day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
			hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
			dim_inactive = false, -- dims inactive windows
			lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
			on_highlights = function(highlights, colors)
				highlights.Function = { fg = colors.yellow }
				highlights.CmpItemKindFunction = { fg = colors.yellow }
				highlights.NoiceCompletionItemKindFunction = { fg = colors.yellow }
				highlights.typescriptFunctionMethod = { fg = colors.yellow }
				highlights.NavicIconsFunction = { fg = colors.yellow }
				highlights["@parameter"] = { fg = colors.blue }
				highlights["@variable"] = { fg = colors.blue }
				highlights.Type = { fg = colors.teal }
			end,
		},
	},

	{
		"rebelot/kanagawa.nvim",
	},
}
