local M = {}

local configured = false

local function load()
  if configured then
    return require("oil")
  end

  vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

  configured = true

  require("oil").setup({
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
    delete_to_trash = false,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        local always_hidden_names = {
          "__pycache__",
          "node_modules",
          "env",
          ".venv",
          ".git",
          ".DS_Store",
          ".vscode",
          ".cache",
          ".idea",
          ".ipynb_checkpoints",
          ".mypy_cache",
          ".pytest_cache",
          ".ruff_cache",
          ".hypothesis",
          ".playwright-cli",
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
  })
  return require("oil")
end

function M.open()
  load()
  vim.cmd("Oil")
end

return M
