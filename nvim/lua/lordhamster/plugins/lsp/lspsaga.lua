return {
	"glepnir/lspsaga.nvim",
	config = function()
		-- import lspsaga safely
		local saga = require("lspsaga")

		-- https://nvimdev.github.io/lspsaga/
		saga.setup({
			ui = {
				kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			},
			outline = {
				keys = {
					toggle_or_jump = "l",
				},
			},
		})

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references
		vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", opts)
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	end,
}
