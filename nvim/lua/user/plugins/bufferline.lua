local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

-- https://github.com/akinsho/bufferline.nvim
-- Use :h bufferline-configuration to check the config
bufferline.setup({
	options = {
		numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		tab_size = 21,
		diagnostics = false, -- | "nvim_lsp" | "coc",
		diagnostics_update_in_insert = false,
		offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center", separator = true } },
		show_buffer_icons = true,
		show_tab_indicators = true,
		persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
		always_show_bufferline = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "insert_at_end",
	},
})
