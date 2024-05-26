-- Find, Filter, Preview, Pick. All lua, all the time.
return {
  -- https://github.com/nvim-telescope/telescope.nvim
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
          },
        },
      },
      pickers = {
        find_files = {
          previewer = false,
          -- path_display = formattedName,
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "bottom",
            preview_cutoff = 120,
          },
        },
        git_files = {
          previewer = false,
          -- path_display = formattedName,
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "bottom",
            preview_cutoff = 120,
          },
        },
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer,
            },
          },
          previewer = false,
          initial_mode = "normal",
          -- theme = "dropdown",
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "bottom",
            preview_cutoff = 120,
          },
        },
        current_buffer_fuzzy_find = {
          previewer = true,
          layout_config = {
            prompt_position = "bottom",
            preview_cutoff = 120,
          },
        },
        live_grep = {
          only_sort_text = true,
          previewer = true,
        },
        grep_string = {
          only_sort_text = true,
          previewer = true,
        },
        lsp_references = {
          show_line = false,
          previewer = true,
        },
        treesitter = {
          show_line = false,
          previewer = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
