-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

local mappings = {
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
	},
}

-- configure telescope
telescope.setup({ defaults = {
	mappings = mappings,
} })

telescope.load_extension("fzf")
