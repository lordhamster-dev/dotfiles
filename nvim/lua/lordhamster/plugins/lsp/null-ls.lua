return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local mason_null_ls = require("mason-null-ls")

		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		local formatting = null_ls.builtins.formatting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local diagnostics = null_ls.builtins.diagnostics

		null_ls.setup({
			debug = false,
			sources = {
				-- html、css、scss、javascript、typescript...
				formatting.prettier,
				-- python
				formatting.black.with({ extra_args = { "--fast", "--skip-string-normalization" } }),
				formatting.reorder_python_imports,
				-- diagnostics.mypy, -- Mypy is an optional static type checker for Python that aims to combine the benefits of dynamic (or "duck") typing and static typing.
				diagnostics.ruff,
				-- lua
				formatting.stylua,
				-- javascript、typescript
				diagnostics.eslint,
				-- typescript import order and organize
				require("typescript.extensions.null-ls.code-actions"),
			},
		})

		mason_null_ls.setup({
			ensure_installed = {
				"prettier",
				"black",
				"reorder_python_imports",
				"ruff",
				"stylua",
			},
			automatic_installation = true,
		})
	end,
}
