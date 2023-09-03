return {
	"williamboman/mason.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"RRethy/vim-illuminate",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local lsp_handler = require("lordhamster.plugins.lsp.conf.lsp_handler")

		local lspconfig = require("lspconfig")

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
		local servers = {
			"clangd",
			-- python
			"pyright",
			-- lua
			"lua_ls",
			-- html
			"html",
			"emmet_ls",
			-- css
			"cssls",
			"tailwindcss",
			-- typescript
			"tsserver",
			-- angular
			"angularls",
			-- other
			"bashls",
			"jsonls",
			"yamlls",
			"astro",
		}
		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_installation = true,
		})

		local opts = {}

		for _, server in pairs(servers) do
			opts = {
				on_attach = lsp_handler.on_attach,
				capabilities = lsp_handler.capabilities,
			}

			server = vim.split(server, "@")[1]

			local require_ok, conf_opts = pcall(require, "lordhamster.plugins.lsp.settings." .. server)
			if require_ok then
				opts = vim.tbl_deep_extend("force", conf_opts, opts)
			end

			lspconfig[server].setup(opts)
		end

		lsp_handler.setup()
	end,
}
