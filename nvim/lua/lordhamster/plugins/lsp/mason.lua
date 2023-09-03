return {
	"williamboman/mason.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"RRethy/vim-illuminate",
		"williamboman/mason-lspconfig.nvim",
		"jose-elias-alvarez/typescript.nvim",
	},
	config = function()
		local lsp_handler_status, lsp_handler = pcall(require, "lordhamster.plugins.lsp.conf.lsp_handler")
		if not lsp_handler_status then
			return
		end

		local lspconfig_status, lspconfig = pcall(require, "lspconfig")
		if not lspconfig_status then
			return
		end

		local mason_status, _ = pcall(require, "mason")
		if not mason_status then
			return
		end

		local mason_lspconfig_status, _ = pcall(require, "mason-lspconfig")
		if not mason_lspconfig_status then
			return
		end

		local typescript_status, typescript = pcall(require, "typescript")
		if not typescript_status then
			return
		end

		local settings = {
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
		}
		require("mason").setup(settings)

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

		-- configure typescript server with plugin
		typescript.setup({
			server = {
				on_attach = lsp_handler.on_attach,
				capabilities = lsp_handler.capabilities,
			},
		})

		lsp_handler.setup()
	end,
}
