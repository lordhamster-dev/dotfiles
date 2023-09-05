return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				border = "none",
				icons = {
					package_installed = "◍",
					package_pending = "◍",
					package_uninstalled = "◍",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		})

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"pyright",
				"lua_ls",
				"html",
				"emmet_ls",
				"cssls",
				"tailwindcss",
				"tsserver",
				"angularls",
				"bashls",
				"jsonls",
				"yamlls",
			},
			automatic_installation = true,
		})
	end,
}
