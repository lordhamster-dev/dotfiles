-- Find, Filter, Preview, Pick. All lua, all the time.
return {
  -- https://github.com/nvim-telescope/telescope.nvim
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- configure telescope
    telescope.setup({
      defaults = {
        preview = {
          timeout = 500,
        },
        prompt_prefix = " ",
        selection_caret = "❯ ",
        sorting_strategy = "ascending",
        color_devicons = true,
        layout_config = {
          prompt_position = "top",
          horizontal = {
            width_padding = 0.04,
            height_padding = 0.1,
            preview_width = 0.5,
          },
          vertical = {
            width_padding = 0.05,
            height_padding = 1,
            preview_height = 0.5,
          },
        },
        -- path_display = { "smart" },
        mappings = {
          -- insert mode
          i = {
            ["<C-\\>"] = actions.file_vsplit,
            ["<C-a>"] = actions.select_all,
            ["<C-h>"] = actions.drop_all,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-l>"] = actions.toggle_selection,
            ["<C-q>"] = actions.smart_send_to_qflist,
          },
          -- normal mode
          n = {
            ["-"] = actions.file_split,
            ["<C-a>"] = actions.select_all,
            ["<C-h>"] = actions.drop_all,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-l>"] = actions.toggle_selection,
            ["<C-q>"] = actions.smart_send_to_qflist,
            ["\\"] = actions.file_vsplit,
            ["l"] = actions.select_default,
          },
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer,
              ["dd"] = actions.delete_buffer,
            },
          },
          previewer = false,
          initial_mode = "normal",
          layout_config = {
            height = 0.4,
            width = 0.6,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            -- even more opts
          }),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}
