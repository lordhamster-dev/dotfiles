-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	print("nvim-treesitter not installed!")
	return
end

local rainbow_status, _ = pcall(require, "ts-rainbow")
if not rainbow_status then
	print("ts-rainbow not installed!")
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = { enable = true },
	-- enable indentation
	indent = { enable = true },
	-- enable autotagging (w/ nvim-ts-autotag plugin)
	autotag = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"python",
		"json",
		"javascript",
		"typescript",
		"yaml",
		"html",
		"css",
		"markdown",
		"markdown_inline",
		"bash",
		"lua",
		"vim",
		"dockerfile",
		"gitignore",
        "sql",
		"astro",
	},
	-- auto install above language parsers
	auto_install = true,
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = true,
	rainbow = {
		enable = true,
		-- list of languages you want to disable the plugin for
		disable = { "jsx", "cpp", "html" },
		-- Which query to use for finding delimiters
		query = "rainbow-parens",
		-- Highlight the entire buffer all at once
		strategy = require("ts-rainbow").strategy.global,
	},
})

local s, _ = pcall(vim.cmd, "set nofoldenable")
if not s then
	print("set nofoldenable error")
	return
end
