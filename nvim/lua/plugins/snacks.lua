vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
  -- This keeps the image on the top right corner, basically leaving your
  -- text area free, suggestion found in reddit by user `Redox_ahmii`
  -- https://www.reddit.com/r/neovim/comments/1irk9mg/comment/mdfvk8b/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  styles = {
    snacks_image = {
      relative = "editor",
      col = -1,
    },
    terminal = {
      keys = {
        term_normal = {
          "<esc>",
          function()
            vim.cmd("stopinsert")
          end,
          mode = "t",
          expr = true,
          desc = "Double escape to normal mode",
        },
      },
    },
  },
  animate = { enabled = true },
  bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true, scope = { enabled = false } },
  input = { enabled = true },
  lazygit = { enabled = true },
  notifier = { enabled = true, top_down = true },
  -- scope = { enabled = true },
  -- scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  picker = {
    enabled = true,
    exclude = {
      ".DS_Store",
      "__pycache__",
      "node_modules",
      "env",
      ".venv",
      ".git",
      ".angular",
      ".cache",
      ".idea",
      ".vscode",
    },
    debug = {
      scores = false, -- show scores in the list
    },
    layout = {
      cycle = true,
    },
    matcher = {
      frecency = true,
    },
    win = {
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          -- ["l"] = { "confirm", mode = { "n" } },
          -- ["J"] = { "preview_scroll_down", mode = { "n" } },
          -- ["K"] = { "preview_scroll_up", mode = { "n" } },
          -- ["H"] = { "preview_scroll_left", mode = { "n" } },
          -- ["L"] = { "preview_scroll_right", mode = { "n" } },
        },
      },
    },
    formatters = {
      file = {
        filename_first = false, -- display filename before the file path
        truncate = 80,
      },
    },
  },
  image = {
    enabled = true,
    img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", "Attachments" },
    doc = {
      inline = vim.g.neovim_mode == "skitty" and true or false,
      float = true,
    },
  },
})
