return {
	"epwalsh/obsidian.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = function()
		vim.keymap.set("n", "gd", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gd"
			end
		end, { noremap = false, expr = true })
		return {
			dir = "/Users/jacob/Library/Mobile Documents/iCloud~md~obsidian/Documents/LordHamster", -- no need to call 'vim.fn.expand' here
			notes_subdir = "3-Permanent",
			completion = {
				-- If using nvim-cmp, otherwise set to false
				nvim_cmp = true,
				-- Trigger completion at 2 chars
				min_chars = 2,
				-- Where to put new notes created from completion. Valid options are
				--  * "current_dir" - put new notes in same directory as the current buffer.
				--  * "notes_subdir" - put new notes in the default notes subdirectory.
				new_notes_location = "notes_subdir",
			},
			-- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
			open_app_foreground = true,

			-- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
			disable_frontmatter = true,

			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				-- ["gf"] = require("obsidian.mapping").gf_passthrough(),
			},
			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({ "open", url }) -- Mac OS
				-- vim.fn.jobstart({"xdg-open", url})  -- linux
			end,
		}
	end,
}
