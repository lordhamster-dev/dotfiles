-- 💥 Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
local codecompanion = require("codecompanion")
local markdown = require("lordhamster.util.markdown")
local obsidian = require("lordhamster.util.obsidian")
local snacks_utils = require("lordhamster.util.snacks_utils")
local terminal = require("lordhamster.util.terminal")
local utils = require("lordhamster.util.utils")

return {
  -- https://github.com/folke/which-key.nvim
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = { preset = "modern" },
  keys = {
    { "<leader>b", snacks_utils.find_buffers, desc = "Buffers" },

    { "<leader>c", group = "CodeCompanion" },
    { "<leader>ca", "<cmd>CodeCompanionAction<CR>", desc = "CodeCompanionAction" },
    { "<leader>ca", "<cmd>CodeCompanionAction<CR>", mode = "v", desc = "CodeCompanionAction" },
    { "<leader>cc", codecompanion.toggle, desc = "Toggle CodeCompanionChat" },
    { "<leader>cp", ":CodeCompanion ", mode = "v", desc = "CodeCompanion" },

    { "<leader>e", "<cmd>Oil<CR>", desc = "File Explorer" },
    { "<leader><leader>", "<cmd>e #<CR>", desc = "Switch to Other Buffer" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
    { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    { "<leader>o", obsidian.open_in_obsidian, mode = "n", desc = "Open in Obsidian" },
    { "<leader>p", '"ap', desc = "Paste from 'a' register" },
    { "<leader>p", '"ap', mode = "v", desc = "Paste from 'a' register" },
    { "<leader>q", "<cmd>:qa<CR>", desc = "Quit Nvim" },
    { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
    { "<leader>x", snacks_utils.bufdelete, desc = "Close buffer" },
    { "<leader>y", "<cmd>let @a = @+<CR>", desc = "Let 'a' register copy from '+' register" },
    { "<leader>y", '"ay', mode = "v", desc = "Copy to 'a' register" },
    { "<leader>z", snacks_utils.zen, desc = "ZenMode" },

    -- Run code
    { "<leader>r", terminal.run_file, desc = "Run current Python file in terminal" },
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
    { "H", "<cmd>tabprev<CR>", desc = "Tab previous" },
    { "L", "<cmd>tabnext<CR>", desc = "Tab next" },

    -- Move stuff up and down in visual mode
    { "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move stuff down" },
    { "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move stuff up" },

    -- Better indenting in visual mode
    { ">", ">gv", mode = "v", desc = "Indent right and reselect" },
    { "<", "<gv", mode = "v", desc = "Indent left and reselect" },

    ----------------------
    --     Terminal     --
    ----------------------
    { "<leader>tt", terminal.toggle_terminal, desc = "Toggle floating terminal" },
    { "<esc>", terminal.toggle_terminal, mode = "t", desc = "Toggle floating terminal" },

    ----------------------
    --       lsp       --
    ----------------------
    { "<leader>l", group = "LSP" },
    { "<leader>lD", snacks_utils.find_document_diagnostics, desc = "Document Diagnostics" },
    { "<leader>lR", "<cmd>LspRestart<CR>", desc = "Restart LSP" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    { "<leader>ld", snacks_utils.find_diagnostics, desc = "Buffer Diagnostics" },
    { "<leader>lf", utils.format_and_save, desc = "Format and save" },
    { "<leader>lg", snacks_utils.lazygit, desc = "LazyGit" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lo", "<cmd>Outline<CR>", desc = "Outline" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>lz", "<cmd>Lazy<cr>", desc = "Lazy" },

    ----------------------
    ---    Markdown     --
    ----------------------
    { "<leader>m", group = "Markdown" },
    { "<leader>mT", "<cmd>LspTomorrow<CR>", desc = "Daily Note Tomorrow" },
    { "<leader>md", markdown.complete_markdown_task, desc = "Mark task done" },
    { "<leader>ml", markdown.markdown_task_later, desc = "Mark task later" },
    { "<leader>mn", markdown.markdown_task_now, desc = "Mark task now" },
    { "<leader>mt", "<cmd>LspToday<CR>", desc = "Daily Note Today" },
    { "<leader>my", "<cmd>LspYesterday<CR>", desc = "Daily Note Yesterday" },

    ----------------------
    --   File Manager   --
    ----------------------
    { "<leader>f", group = "File Manager" },
    { "<leader>fT", snacks_utils.find_todo_comments, desc = "Find todos" },
    { "<leader>fb", snacks_utils.find_buffers, desc = "Buffers" },
    { "<leader>fc", snacks_utils.find_complete_tasks, desc = "Search complete tasks" },
    { "<leader>fe", snacks_utils.explorer, desc = "File Explorer" },
    { "<leader>ff", snacks_utils.find_files, desc = "Find files" },
    { "<leader>fg", snacks_utils.find_git_files, desc = "Find Git Files" },
    { "<leader>fh", snacks_utils.find_help, desc = "Help" },
    { "<leader>fk", snacks_utils.find_keymaps, desc = "Keymaps" },
    { "<leader>fq", snacks_utils.find_qflist, desc = "Quickfix" },
    { "<leader>fr", snacks_utils.find_recent, desc = "Recently used files" },
    { "<leader>fs", snacks_utils.find_grep, desc = "Grep" },
    { "<leader>ft", snacks_utils.find_todo, desc = "Search incomplete tasks" },

    ----------------------
    --       Git       --
    ----------------------
    { "<leader>g", group = "Git" },
    { "<leader>gP", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
    { "<leader>gl", snacks_utils.git_log, desc = "Git Log" },
    { "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },

    ----------------------
    ---     LÖVE        --
    ----------------------
    { "<leader>v", ft = "lua", desc = "LÖVE", group = "Telescope" },
    { "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
    { "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
  },
}
