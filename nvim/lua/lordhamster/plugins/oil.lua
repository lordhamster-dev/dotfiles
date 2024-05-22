-- Neovim file explorer: edit your filesystem like a buffer
return {
  -- https://github.com/stevearc/oil.nvim
  "stevearc/oil.nvim",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    keymaps = {
      ["<C-s>"] = false,
      ["<C-h>"] = false,
      ["<C-\\>"] = "actions.select_vsplit",
      ["_"] = false,
      ["<Tab>"] = "actions.open_cwd",
    },
    view_options = {
      show_hidden = true,
    },
  },
}
