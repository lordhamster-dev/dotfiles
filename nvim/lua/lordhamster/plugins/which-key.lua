return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	config = function()
		local wk = require("which-key")

		local setup = {
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
					motions = true, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},
			-- add operators that will trigger motion and text object completion
			-- to enable all native operators, set the preset / operators plugin above
			-- operators = { gc = "Comments" },
			key_labels = {
				-- override the label used to display some keys. It doesn't effect WK in any other way.
				-- For example:
				-- ["<space>"] = "SPC",
				-- ["<cr>"] = "RET",
				-- ["<tab>"] = "TAB",
			},
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},
			popup_mappings = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
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
			ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
			show_help = true, -- show help message on the command line when the popup is visible
			show_keys = true, -- show the currently pressed key and its label as a message in the command line
			triggers = "auto", -- automatically setup triggers
			-- triggers = {"<leader>"} -- or specify a list manually
			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				-- this is mostly relevant for key maps that start with a native binding
				-- most people should not need to change this
				i = { "j", "k" },
				v = { "j", "k" },
			},
		}

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
			["e"] = { "<cmd>NvimTreeFocus<cr>", "Explorer" },
			["w"] = { "<cmd>w!<CR>", "Save" },
			["q"] = { "<cmd>:qa<CR>", "Quit Nvim" },
			["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
			["o"] = { "<cmd>Lspsaga outline<CR>", "Outline" },
			["t"] = { "<cmd>Lspsaga term_toggle<CR>", "Term Toggle" },
			["x"] = { "<cmd>:Bdelete!<CR>", "Close Buffer" },

			f = {
				name = "File",
				t = { "<cmd>NvimTreeToggle<cr>", "Toggle Explorer" },
				f = { "<cmd>Telescope find_files<cr>", "Find file" },
				g = { "<cmd>Telescope live_grep<cr>", "Find text" }, -- find string in current working directory as you type
				r = { "<cmd>Telescope oldfiles<cr>", "Recently used files" },
				q = { "<cmd>copen<cr>", "Quickfix" },
				h = { "<cmd>Telescope help_tags<cr>", "Help" }, -- list available help tags
			},
			n = {
				name = "NPM",
				b = { "<cmd>NPMRunBuild<cr>", "npm run build" },
				d = { "<cmd>NPMRunDeploy<cr>", "npm run deploy" },
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
			l = {
				name = "LSP",
				R = { "<cmd>LspRestart<CR>", "Restart LSP" },
				a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
				d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
				w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
				f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
				i = { "<cmd>LspInfo<cr>", "Info" },
				l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
				r = { "<cmd>Lspsaga rename<cr>", "Rename" },
			},
		}
		wk.setup(setup)
		wk.register(mappings, opts)
	end,
}
