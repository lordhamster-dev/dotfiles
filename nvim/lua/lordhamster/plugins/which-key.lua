-- 💥 Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
return {
  -- https://github.com/folke/which-key.nvim
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = { preset = "modern" },
  keys = {
    { "<leader><Space>", "<cmd>e #<CR>", desc = "Switch to Other Buffer" },
    { "<leader>a", "<cmd>lua require('harpoon'):list():add()<cr>", desc = "Harpoon add" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>c", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>e", "<cmd>Oil<cr>", desc = "Oil" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
    { "<leader>p", '"ap', desc = "Paste from 'a' register" },
    { "<leader>q", "<cmd>:qa<CR>", desc = "Quit Nvim" },
    { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
    { "<leader>y", "<cmd>let @a = @+<CR>", desc = "Let 'a' register copy from '+' register" },
    { "<leader>z", "<cmd>ZenMode<CR>", desc = "ZenMode" },

    -- Run lua
    { "<space>s", "<cmd>source %<CR>", desc = "Run whole file" },
    { "<space>r", ":.lua<CR>", desc = "Run lua on current cursor" },
    { "<space>r", ":lua<CR>", mode = "v", desc = "Run lua on select" },

    -- Without copying into register
    { "x", '"_x', desc = "x without copying into register" },
    { "c", '"_c', desc = "c without copying into register" },

    -- Window
    { "<C-w>\\", ":vsp<CR>", desc = "c without copying into register" },
    { "<C-w>-", ":sp<CR>", desc = "c without copying into register" },

    -- Markdown
    { "<C-t>", "- [ ] ", mode = "i", desc = "Create a todo in markdown" },

    -- Buffers & Tabs
    { "<leader>tm", ":tabmove ", desc = "Move tab" },
    { "<space>n", "<cmd>tabnew<CR>", desc = "New tab" },
    { "<space>x", "<cmd>bdelete!<CR>", desc = "Delete buffer" },
    { "H", "<cmd>tabprevious<CR>", desc = "Tab previous" },
    { "L", "<cmd>tabnext<CR>", desc = "Tab next" },

    -- Move stuff up and down in visual mode
    { "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move stuff down" },
    { "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move stuff up" },

    ----------------------
    --   Myself Tool   --
    ----------------------
    { "<esc>", "<C-\\><C-n>", mode = "t", desc = "Terminal mode to normal mode" },
    { "<leader>tt", "<cmd>Floaterminal<cr>", desc = "Toggle floating terminal" },
    { "<leader>tt", "<cmd>Floaterminal<cr>", mode = "t", desc = "Toggle floating terminal" },

    ----------------------
    --    Telescope    --
    ----------------------
    { "<leader>f", group = "File Manage" },
    { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current buffer fuzzy find" },
    { "<leader>fc", "<cmd>cexpr []<cr>", desc = "Clear Quickfix" },
    {
      "<leader>ff",
      "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
      desc = "Find file",
    },
    { "<leader>fg", "<cmd>Telescope git_status<cr>", desc = "Telescope git files" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fl", "<cmd>ToggleHarpoonList<cr>", desc = "Harpoon quick menu" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
    { "<leader>fq", "<cmd>copen<cr>", desc = "Quickfix" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recently used files" },
    { "<leader>fs", "<cmd>TelescopeCustomLiveGrep<cr>", desc = "Search text(1 regex,2 full match,3 case sensitive)" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
    { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },

    ----------------------
    --       lsp       --
    ----------------------
    { "<leader>l", group = "LSP" },
    { "<leader>lR", "<cmd>LspRestart<CR>", desc = "Restart LSP" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lo", "<cmd>Outline<CR>", desc = "Outline" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>lz", "<cmd>Lazy<cr>", desc = "Lazy" },

    ----------------------
    --       Git       --
    ----------------------
    { "<leader>g", group = "Git" },
    { "<leader>gP", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
    { "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },

    ----------------------
    --     Obsidian    --
    ----------------------
    { "<leader>o", group = "Obsidian" },
    { "<leader>oT", "<cmd>ObsidianTags<cr>", desc = "Obsidian tags" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian backlinks" },
    { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Obsidian toggle checkbox" },
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Obsidian dailies" },
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian find files" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian new" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian open" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian find text" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian template" },

    ----------------------
    --   Taskwarrior   --
    ----------------------
    { "<leader>t", group = "Taskwarrior" },
    { "<leader>tQ", "<cmd>TWBufQueryTasks<cr>", desc = "Taskwarrior query task in buffer" },
    { "<leader>td", "<cmd>TWToggle<cr>", desc = "Taskwarrior toggle task" },
    { "<leader>tq", "<cmd>TWQueryTasks<cr>", desc = "Taskwarrior query task" },
    { "<leader>ts", "<cmd>TWSyncTasks<cr>", desc = "Taskwarrior sync" },
    { "<leader>tu", "<cmd>TWUpdateCurrent<cr>", desc = "Taskwarrior update task" },
  },
}
