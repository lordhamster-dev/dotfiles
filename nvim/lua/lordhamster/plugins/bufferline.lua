-- A snazzy bufferline for Neovim
local snacks_utils = require("lordhamster.util.snacks_utils")

return {
  -- https://github.com/akinsho/bufferline.nvim
  "akinsho/bufferline.nvim",
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center", separator = true } },
      max_name_length = 30,
      max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
      close_command = snacks_utils.bufdelete, -- can be a string | function, see "Mouse actions"
      right_mouse_command = snacks_utils.bufdelete, -- can be a string | function, see "Mouse actions"
      -- numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
      -- tab_size = 21,
      -- diagnostics = false, -- | "nvim_lsp" | "coc",
      -- diagnostics_update_in_insert = false,
      -- show_buffer_icons = true,
      -- show_tab_indicators = true,
      -- persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
      -- always_show_bufferline = true,
      -- hover = {
      --   enabled = true,
      --   delay = 200,
      --   reveal = { "close" },
      -- },
      -- sort_by = "insert_at_end",
    },
  },
}
