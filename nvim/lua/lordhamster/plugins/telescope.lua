return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		-- configure telescope
		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					-- insert mode
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-\\>"] = actions.file_vsplit,
					},
					-- normal mode
					n = {
						["l"] = actions.toggle_selection,
						["L"] = actions.select_all,
						["H"] = actions.drop_all,
						["-"] = actions.file_split,
						["\\"] = actions.file_vsplit,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.smart_send_to_qflist,
						["dd"] = actions.delete_buffer,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })

		vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy Find files" })
		vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find text" })
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recently used files" })

		vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
		vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

		vim.keymap.set("n", "<leader>fq", "<cmd>copen<cr>", { desc = "Quickfix" })

		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
