-- 💥 Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
return {
  -- https://github.com/folke/which-key.nvim
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = { preset = "modern" },
  keys = {
    { "<leader>c", group = "CodeCompanion" },
    { "<leader>ca", "<cmd>CodeCompanionAction<CR>", desc = "CodeCompanionAction" },
    { "<leader>ca", "<cmd>CodeCompanionAction<CR>", mode = "v", desc = "CodeCompanionAction" },
    { "<leader>cc", require("codecompanion").toggle, desc = "Toggle CodeCompanionChat" },
    { "<leader>cp", ":CodeCompanion ", mode = "v", desc = "CodeCompanion" },

    { "<leader>e", group = "Explorer" },
    { "<leader>ee", "<cmd>NvimTreeFindFile<CR>", desc = "File Explorer Find File" },
    { "<leader>ec", "<cmd>NvimTreeClose<CR>", desc = "Close File Explorer" },
    { "<leader>et", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh File Explorer" },

    { "<leader><leader>", "<cmd>e #<CR>", desc = "Switch to Other Buffer" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
    { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    { "<leader>o", require("lordhamster.util.obsidian").open_in_obsidian, mode = "n", desc = "Open in Obsidian" },
    { "<leader>p", '"ap', desc = "Paste from 'a' register" },
    { "<leader>p", '"ap', mode = "v", desc = "Paste from 'a' register" },
    { "<leader>q", "<cmd>:qa<CR>", desc = "Quit Nvim" },
    { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
    { "<leader>x", require("lordhamster.util.buffer").close_buffer_preserve_window, desc = "Close buffer" },
    { "<leader>y", "<cmd>let @a = @+<CR>", desc = "Let 'a' register copy from '+' register" },
    { "<leader>y", '"ay', mode = "v", desc = "Copy to 'a' register" },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "ZenMode",
    },

    -- Run code
    {
      "<leader>r",
      function()
        if vim.bo.filetype == "python" then
          vim.cmd("w")
          -- Open terminal in split and run Python
          vim.cmd("split | terminal python " .. vim.fn.shellescape(vim.fn.expand("%")))
        elseif vim.bo.filetype == "lua" then
          vim.cmd("w")
          -- Open terminal in split and run Lua
          vim.cmd("split | terminal lua " .. vim.fn.shellescape(vim.fn.expand("%")))
        else
          vim.notify("Not a Python file", vim.log.levels.WARN, { title = "Run Python" })
        end
      end,
      desc = "Run current Python file in terminal",
    },
    { "<leader>r", ":lua<CR>", mode = "v", desc = "Excute lua on select" },
    { "<leader>R", "<cmd>source %<CR>", desc = "Excute whole file" },

    -- Without copying into register
    { "x", '"_x', desc = "x without copying into register" },
    { "c", '"_c', desc = "c without copying into register" },

    -- Window
    { "<C-w>\\", ":vsp<CR>", desc = "Split windown vertically" },
    { "<C-w>-", ":sp<CR>", desc = "Split windown horizontally" },
    { "<C-d>", "<C-d>zz", desc = "Scroll down and center" },
    { "<C-u>", "<C-u>zz", desc = "Scroll up and center" },
    { "G", "Gzz", desc = "Scroll to bottom and center" },

    -- Buffers & Tabs
    { "<leader>tc", "<cmd>tabclose<CR>", desc = "Close tab" },
    { "<leader>tm", ":tabmove ", desc = "Move tab" },
    { "<leader>tn", "<cmd>tabnew<CR>", desc = "New tab" },
    { "H", "<cmd>BufferLineCyclePrev<CR>", desc = "Tab previous" },
    { "L", "<cmd>BufferLineCycleNext<CR>", desc = "Tab next" },

    -- Move stuff up and down in visual mode
    { "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move stuff down" },
    { "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move stuff up" },

    -- Better indenting in visual mode
    { ">", ">gv", mode = "v", desc = "Indent right and reselect" },
    { "<", "<gv", mode = "v", desc = "Indent left and reselect" },

    ----------------------
    --   Myself Tool   --
    ----------------------
    {
      "<leader>tt",
      "<cmd>lua require 'lordhamster.util.terminal'.toggle_terminal()<cr>",
      desc = "Toggle floating terminal",
    },
    {
      "<esc>",
      "<cmd>lua require 'lordhamster.util.terminal'.toggle_terminal()<cr>",
      mode = "t",
      desc = "Toggle floating terminal",
    },

    ----------------------
    --       lsp       --
    ----------------------
    { "<leader>l", group = "LSP" },
    { "<leader>lR", "<cmd>LspRestart<CR>", desc = "Restart LSP" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    {
      "<leader>ld",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>lD",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Document Diagnostics",
    },
    {
      "<leader>lg",
      function()
        Snacks.lazygit()
      end,
      desc = "LazyGit",
    },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lo", "<cmd>Outline<CR>", desc = "Outline" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>lz", "<cmd>Lazy<cr>", desc = "Lazy" },

    ----------------------
    --   File Manager   --
    ----------------------
    { "<leader>f", group = "File Manager" },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps({
          layout = "vertical",
        })
      end,
      desc = "Keymaps",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers({ -- I always want my buffers picker to start in normal mode
          on_show = function()
            vim.cmd.stopinsert()
          end,
          finder = "buffers",
          format = "buffer",
          hidden = false,
          unloaded = true,
          current = true,
          sort_lastused = true,
          win = {
            input = {
              keys = {
                ["d"] = "bufdelete",
              },
            },
            list = { keys = { ["d"] = "bufdelete" } },
          },
        })
      end,
      desc = "Buffers",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help",
    },
    {
      "<leader>fq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recently used files",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.grep()
      end,
      desc = "Search text",
    },
    {
      -- -- You can confirm in your teminal lamw26wmal with:
      -- -- rg "^\s*-\s\[ \]" test-markdown.md
      "<leader>ft",
      function()
        Snacks.picker.grep({
          prompt = " ",
          -- pass your desired search as a static pattern
          search = "^\\s*- \\[ \\]",
          -- we enable regex so the pattern is interpreted as a regex
          regex = true,
          -- no “live grep” needed here since we have a fixed pattern
          live = false,
          -- restrict search to the current working directory
          dirs = { vim.fn.getcwd() },
          -- include files ignored by .gitignore
          args = { "--no-ignore" },
          -- Start in normal mode
          on_show = function()
            vim.cmd.stopinsert()
          end,
          finder = "grep",
          format = "file",
          show_empty = true,
          supports_live = false,
        })
      end,
      desc = "[P]Search for incomplete tasks",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.grep({
          prompt = " ",
          -- pass your desired search as a static pattern
          search = "^\\s*- \\[x\\]",
          -- we enable regex so the pattern is interpreted as a regex
          regex = true,
          -- no “live grep” needed here since we have a fixed pattern
          live = false,
          -- restrict search to the current working directory
          dirs = { vim.fn.getcwd() },
          -- include files ignored by .gitignore
          args = { "--no-ignore" },
          -- Start in normal mode
          on_show = function()
            vim.cmd.stopinsert()
          end,
          finder = "grep",
          format = "file",
          show_empty = true,
          supports_live = false,
        })
      end,
      desc = "[P]Search for complete tasks",
    },
    {
      "<leader>fT",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Find todos",
    },

    ----------------------
    --       Git       --
    ----------------------
    { "<leader>g", group = "Git" },
    { "<leader>gP", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log({
          finder = "git_log",
          format = "git_log",
          preview = "git_show",
          confirm = "git_checkout",
          layout = "vertical",
        })
      end,
      desc = "Git Log",
    },
    { "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
  },
}
