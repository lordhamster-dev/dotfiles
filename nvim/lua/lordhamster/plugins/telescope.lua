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
  end,
}
