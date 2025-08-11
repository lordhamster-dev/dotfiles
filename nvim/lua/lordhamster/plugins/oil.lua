-- Neovim file explorer: edit your filesystem like a buffer
return {
  -- https://github.com/stevearc/oil.nvim
  "stevearc/oil.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  opts = {
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<C-r>"] = "actions.refresh",
      ["<C-s>"] = false,
      ["<Esc>"] = "actions.close",
      ["h"] = "actions.parent",
      ["l"] = "actions.select",
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        local always_hidden_names = {
          -- "..",
          ".git",
          "__pycache__",
          ".venv",
          "env",
          ".ipynb_checkpoints",
          ".DS_Store",
          "node_modules",
          ".angular",
        }
        for _, hidden_name in ipairs(always_hidden_names) do
          if name == hidden_name then
            return true
          end
        end
        return false
      end,
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = true,
    },
  },
}
