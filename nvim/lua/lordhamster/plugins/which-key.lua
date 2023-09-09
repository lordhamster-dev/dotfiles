return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	config = function()
		local wk = require("which-key")

		local opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}

		local mappings = {
			["a"] = { "<cmd>Alpha<cr>", "Alpha" },
			["w"] = { "<cmd>w!<CR>", "Save" },
			["q"] = { "<cmd>:qa<CR>", "Quit Nvim" },
			["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
			["o"] = { "<cmd>Lspsaga outline<CR>", "Outline" },
			["t"] = { "<cmd>Lspsaga term_toggle<CR>", "Term Toggle" },
			["x"] = { "<cmd>:Bdelete!<CR>", "Close Buffer" },

			e = {
				name = "NvimTree",
				e = { "<cmd>NvimTreeFocus<cr>", "File explorer focus" },
				t = { "<cmd>NvimTreeToggle<cr>", "File explorer toggle" },
				f = { "<cmd>NvimTreeFindFile<cr>", "Find current file on file explorer" },
				c = { "<cmd>NvimTreeCollapse<cr>", "Collapse file explorer" },
				r = { "<cmd>NvimTreeRefresh<cr>", "Refresh file explorer" },
			},
			f = {
				name = "File Manage",
				l = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon quick menu" },
				a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Harpoon add" },
				n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Harpoon next" },
				N = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Harpoon prev" },
				f = { "<cmd>Telescope find_files<cr>", "Find file" },
				g = { "<cmd>Telescope live_grep<cr>", "Find text" }, -- find string in current working directory as you type
				r = { "<cmd>Telescope oldfiles<cr>", "Recently used files" },
				q = { "<cmd>copen<cr>", "Quickfix" },
				h = { "<cmd>Telescope help_tags<cr>", "Help" }, -- list available help tags
				m = { "<cmd>Telescope marks<cr>", "Marks" },
				b = { "<cmd>Telescope buffers<cr>", "Buffers" },
			},
			l = {
				name = "LSP",
				R = { "<cmd>LspRestart<CR>", "Restart LSP" },
				-- f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
				a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
				r = { "<cmd>Lspsaga rename<cr>", "Rename" },
				i = { "<cmd>LspInfo<cr>", "Info" },
				d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
				w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
				z = { "<cmd>Lazy<cr>", "Lazy" },
			},
			g = {
				name = "Git",
				b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
			},
		}

		wk.setup({
			window = {
				border = "double", -- none, single, double, shadow
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "center", -- align columns left, center or right
			},
		})
		wk.register(mappings, opts)
	end,
}
