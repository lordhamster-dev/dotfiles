return {
	"mhartington/formatter.nvim",
	event = "VeryLazy",
	opts = function()
		local util = require("formatter.util")
		local M = {
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				python = {
					function()
						return {
							exe = "black",
							args = {
								"--stdin-filename",
								util.escape_path(util.get_current_buffer_file_path()),
								"--quiet",
								"--fast",
								"--skip-string-normalization",
								"-",
							},
							stdin = true,
						}
					end,
					function()
						return {
							exe = "reorder-python-imports",
							args = { "-", "--exit-zero-even-if-changed" },
							stdin = true,
						}
					end,
				},
				html = {
					require("formatter.filetypes.html").prettier,
				},
				css = {
					require("formatter.filetypes.css").prettier,
				},
				javascript = {
					require("formatter.filetypes.javascript").prettier,
				},
				typescript = {
					require("formatter.filetypes.typescript").prettier,
				},
				["*"] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			command = "FormatWriteLock",
		})

		return M
	end,
}
