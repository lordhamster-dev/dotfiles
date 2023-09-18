return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		-- https://github.com/catppuccin/nvim
		local catppuccin = require("catppuccin")

		catppuccin.setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = {
				-- :h background
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			show_end_of_buffer = false, -- show the '~' characters after the end of buffers
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = { "italic" },
				functions = { "bold" },
				keywords = { "italic" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = { "italic" },
				properties = {},
				types = { "bold" },
				operators = { "italic" },
			},
			color_overrides = {},
			custom_highlights = {},
			integrations = {
				mason = true,
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
				leap = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		})

		-- set colorscheme with protected call
		-- in case it isn't installed
		local status, _ = pcall(vim.cmd, "colorscheme catppuccin")
		if not status then
			print("Colorscheme not found!") -- print error if colorscheme not installed
			return
		end

		local highlight_linenumber, _ = pcall(vim.cmd, "hi LineNr guifg=#fff")
		if not highlight_linenumber then
			print("Set linenumber highlight wrong!")
			return
		end
	end,
}
