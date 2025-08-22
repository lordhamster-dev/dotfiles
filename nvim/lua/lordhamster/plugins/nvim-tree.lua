-- A file explorer tree for neovim written in lua
return {
  -- https://github.com/nvim-tree/nvim-tree.lua
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- import nvim-tree plugin safely
    local nvimtree = require("nvim-tree")

    -- remove winbar from nvim tree
    local api = require("nvim-tree.api")
    api.events.subscribe(api.events.Event.TreeOpen, function()
      vim.opt.winbar = " "
    end)

    -- change color for arrows in tree to light blue
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

    -- float window position
    local gwidth = vim.api.nvim_list_uis()[1].width
    local gheight = vim.api.nvim_list_uis()[1].height
    local width = math.ceil(gwidth / 1.5)
    local height = math.ceil(gheight / 1.5)

    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

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
    nvimtree.setup({
      on_attach = on_attach,
      renderer = {
        root_folder_modifier = ":t",
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
              staged = "S",
              unmerged = "",
              renamed = "➜",
              untracked = "U",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      diagnostics = { enable = false },
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
