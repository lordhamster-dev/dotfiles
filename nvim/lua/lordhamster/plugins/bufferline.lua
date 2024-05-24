-- A snazzy bufferline for Neovim
return {
  -- https://github.com/akinsho/bufferline.nvim
  "akinsho/bufferline.nvim",
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    "nvim-tree/nvim-web-devicons",
  },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
    },
  },
}
