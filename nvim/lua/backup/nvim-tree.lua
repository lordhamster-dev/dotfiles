-- A file explorer tree for neovim written in lua
return {
  -- https://github.com/nvim-tree/nvim-tree.lua
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    require("mini.icons").mock_nvim_web_devicons()

    -- remove winbar from nvim tree
    local api = require("nvim-tree.api")
    api.events.subscribe(api.events.Event.TreeOpen, function()
      vim.opt.winbar = " "
    end)

    -- float window position
    local gwidth = vim.api.nvim_list_uis()[1].width
    local gheight = vim.api.nvim_list_uis()[1].height
    local width = math.ceil(gwidth / 1.5)
    local height = math.ceil(gheight / 1.5)

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
      vim.keymap.set("n", "-", api.node.open.horizontal, opts("Open: Horizontal Split"))
      vim.keymap.set("n", "\\", api.node.open.vertical, opts("Open: Vertical Split"))
    end

    -- configure nvim-tree
    local nvimtree = require("nvim-tree")
    nvimtree.setup({
      on_attach = on_attach,
      git = { ignore = false },
      diagnostics = { enable = false },
      filters = {
        custom = {
          ".DS_Store",
          "__pycache__",
          ".venv",
          "env",
          "node_modules",
          ".angular",
          ".cache",
          ".idea",
          ".vscode",
        },
      },
      renderer = {
        root_folder_modifier = ":t",
        indent_width = 2,
        indent_markers = { enable = false },
        icons = {
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_open = "",
              arrow_closed = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      view = {
        -- width = width,
        adaptive_size = true,
        centralize_selection = true,
        preserve_window_proportions = true,
        -- float = {
        --   enable = true,
        --   quit_on_focus_loss = true,
        --   open_win_config = {
        --     relative = "editor",
        --     border = "rounded",
        --     width = width,
        --     height = height,
        --     row = (gheight - height) * 0.5,
        --     col = (gwidth - width) * 0.5,
        --   },
        -- },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      -- actions = {
      --   open_file = {
      --     quit_on_open = true,
      --     window_picker = {
      --       enable = false,
      --     },
      --   },
      -- },
    })
  end,
}
