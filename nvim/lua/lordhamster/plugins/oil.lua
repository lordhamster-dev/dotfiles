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
    },
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
  },
}
