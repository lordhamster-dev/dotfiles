return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- https://github.com/lewis6991/gitsigns.nvim
		require("gitsigns").setup({
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		})
	end,
}
