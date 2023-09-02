-- https://github.com/lukas-reineke/indent-blankline.nvim
local setup, indent_blankline = pcall(require, "indent_blankline")
if not setup then
	return
end

indent_blankline.setup({
	show_end_of_line = true,
	space_char_blankline = " ",
})
