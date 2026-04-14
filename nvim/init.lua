-- ==============================================================
-- 通用 Neovim 设置
-- ==============================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.encoding = "UTF-8"
vim.opt.fileencoding = "utf-8"
vim.opt.scrolloff = 8 -- jk移动时光标上下方保留8行
vim.opt.mousemoveevent = true
vim.opt.list = true
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- For fold
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.fillchars = { fold = " " } -- 用空格替代点
vim.opt.foldexpr = "v:lua.require('util.foldmethod').foldexpr()"
vim.wo.foldtext = "v:lua.require('util.foldmethod').markdown_foldtext()"

vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.wrap = false -- disable line wrapping
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom
vim.opt.iskeyword:append("-") -- consider string-string as whole word
vim.opt.winbar = "%=%t"
vim.opt.winborder = "rounded"
vim.opt.conceallevel = 1

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Auto save
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
-- 	pattern = { "*" },
-- 	command = "silent! wall",
-- 	nested = true,
-- })

-- ==============================================================
-- 插件花名册
-- ==============================================================
local plugins = {
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
  { src = "https://github.com/folke/which-key.nvim" },
}
vim.pack.add(plugins)

-- ==============================================================
-- LSP
-- ==============================================================
local signs = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = "󰠠 ",
  [vim.diagnostic.severity.INFO] = " ",
}

vim.diagnostic.config({
  signs = { text = signs },
  virtual_text = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

require("mason").setup({
  ui = {
    border = "none",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "clangd",
    "html",
    "emmet_ls",
    "cssls",
    "tailwindcss",
    "ts_ls",
    "angularls",
    "bashls",
    "jsonls",
    "yamlls",
    "astro",
    "markdown_oxide",
  },
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "clang-format", -- c,cpp formatter
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "biome", -- js linter
    "ruff", -- python linter
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim", "Snacks", "hs" },
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = "Show LSP definitions"
    -- keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- 使用内置 LSP 跳转到定义
    vim.keymap.set("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, opts)

    opts.desc = "Show LSP references"
    -- keymap.set("n", "gr", vim.lsp.buf.references, opts) -- 使用内置 LSP 显示引用
    vim.keymap.set("n", "gr", function()
      Snacks.picker.lsp_references()
    end, opts)

    opts.desc = "Show LSP implementations"
    -- keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- 使用内置 LSP 跳转到实现
    vim.keymap.set("n", "gi", function()
      Snacks.picker.lsp_implementations()
    end, opts)

    opts.desc = "Float Diagnostic"
    vim.keymap.set("n", "go", vim.diagnostic.open_float, opts)
  end,
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "biome",
  "ruff",
  "clangd",
  "html",
  "emmet_ls",
  "cssls",
  "tailwindcss",
  "ts_ls",
  "angularls",
  "bashls",
  "jsonls",
  "yamlls",
  "astro",
  "markdown_oxide",
})

-- ==============================================================
-- 主题以及基础插件
-- ==============================================================
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true,
  float = {
    transparent = true, -- enable transparent floating windows
    solid = false, -- use solid styling for floating windows, see |winborder|
  },
  show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  term_colors = true,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = { "italic" },
    functions = { "bold" },
    keywords = { "italic" },
    strings = {},
    variables = {},
    numbers = {},
    booleans = { "italic" },
    properties = {},
    types = { "bold" },
    operators = { "italic" },
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    snacks = {
      enabled = true,
      indent_scope_color = "base", -- catppuccin color (eg. `lavender`) Default: text
    },
    noice = true,
    render_markdown = true,
    mason = true,
    cmp = false,
    blink_cmp = {
      style = "bordered",
    },
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    which_key = true,
    harpoon = true,
    flash = true,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})
local parsers = {
  "lua",
  "python",
  "javascript",
  "typescript",
  "html",
  "css",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "vim",
  "dockerfile",
  "gitignore",
  "sql",
  "astro",
}
require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
  pattern = parsers,
  callback = function()
    vim.treesitter.start()
  end,
})
vim.cmd("colorscheme catppuccin-nvim")

-- ==============================================================
-- mini系列插件
-- ==============================================================
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup()

-- ==============================================================
-- 文件管理器
-- ==============================================================
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
})

-- ==============================================================
-- Lualine
-- ==============================================================
local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local mode = {
  "mode",
  separator = { left = "", right = "" },
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_lsp", "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = true,
  update_in_insert = false,
  always_visible = true,
  separator = { left = "", right = "" },
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local location = {
  "location",
  padding = { left = 0, right = 1 },
  separator = { left = "", right = "" },
}

local progress = {
  "progress",
  padding = { left = 1, right = 0 },
  separator = { left = "", right = "" },
}

local filename = {
  "filename",
  path = 0,
  symbols = {
    modified = "", -- Text to show when the file is modified.
    readonly = "[Read Only]", -- Text to show when the file is non-modifiable or readonly.
    unnamed = " ", -- Text to show for unnamed buffers.
    newfile = "[New]", -- Text to show for newly created file before first write
  },
  fmt = function(str)
    -- 如果是终端缓冲区，返回空字符串
    if vim.bo.buftype == "terminal" then
      return ""
    end
    return str -- 否则返回原始文件名
  end,
}

local base_filename = {
  "filename",
  path = 1,
  symbols = {
    modified = "", -- Text to show when the file is modified.
    readonly = "[Read Only]", -- Text to show when the file is non-modifiable or readonly.
    unnamed = " ", -- Text to show for unnamed buffers.
    newfile = "[New]", -- Text to show for newly created file before first write
  },
  fmt = function(str)
    -- 如果是终端缓冲区，返回空字符串
    if vim.bo.buftype == "terminal" then
      return ""
    end
    return str -- 否则返回原始文件名
  end,
}

local tabs = {
  "tabs",
  max_length = vim.o.columns,
  -- 0: Shows tab_nr
  -- 1: Shows tab_name
  -- 2: Shows tab_nr + tab_name
  mode = 0,
  -- 0: just shows the filename
  -- 1: shows the relative path and shorten $HOME to ~
  -- 2: shows the full path
  -- 3: shows the full path and shorten $HOME to ~
  path = 0,
}

local spaces = function()
  return "spaces: " .. vim.bo.shiftwidth
end

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "catppuccin-nvim",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "codecompanion", "dashboard", "NvimTree", "Outline", "oil", "" }, -- "" 表示terminal
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch, diagnostics },
    lualine_c = { diff },
    lualine_x = { spaces, "encoding", "filetype" },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},

    lualine_y = {},
    lualine_z = { tabs },
  },
  winbar = {
    lualine_a = { filename },
    lualine_b = {},
    lualine_c = {},
    lualine_x = { base_filename },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = { filename },
    lualine_b = {},
    lualine_c = {},
    lualine_x = { base_filename },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {},
})

-- ==============================================================
-- 格式化
-- ==============================================================
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
    javascript = { "biome", "biome-organize-imports" },
    typescript = { "biome", "biome-organize-imports" },
    typescriptreact = { "biome", "biome-organize-imports" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    rust = { "rustfmt", lsp_format = "fallback" },
    ["_"] = { "trim_whitespace" },
  },
})

-- ==============================================================
-- 补全
-- ==============================================================
require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<C-m>"] = { "show", "show_documentation", "hide_documentation" },
    -- 更改成'select_and_accept'会选择第一项插入
    -- fallback命令将运行下一个非闪烁键盘映射(回车键的默认换行等操作需要)
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "accept", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-e>"] = { "snippet_forward", "fallback" },
    ["<C-u>"] = { "snippet_backward", "fallback" },
  },
  completion = {
    -- 示例：使用'prefix'对于'foo_|_bar'单词将匹配'foo_'(光标前面的部分),使用'full'将匹配'foo__bar'(整个单词)
    keyword = { range = "full" },
    -- 选择补全项目时显示文档(0.5秒延迟)
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    -- 不预选第一个项目，选中后自动插入该项目文本
    list = { selection = { preselect = false, auto_insert = true } },
  },
  -- 已定义启用的提供程序的默认列表，以便您可以扩展它
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})

-- ==============================================================
-- Git相关
-- ==============================================================
require("gitsigns").setup({
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
})

-- ==============================================================
-- Copilot
-- ==============================================================
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = false,
    debounce = 50, -- 降低debounce时间，提高响应速度
    keymap = {
      accept = "<C-l>",
      accept_word = false,
      accept_line = false,
      next = "<C-]>", -- 保持优化后的上下导航
      prev = "<C-[]>",
      dismiss = "<C-m>",
    },
  },
  filetypes = {
    ["*"] = false, -- 默认禁用所有文件类型
    markdown = true,
    lua = true,
    python = true,
    html = true,
    css = true,
    typescript = true,
    javascript = true,
    rust = true,
    cpp = true,
    c = true,
    go = true,
    sh = true,
    json = true,
    yaml = true,
    toml = true,
  },
  panel = {
    enabled = false, -- 禁用面板模式
  },
})

-- ==============================================================
-- 生活质量提高插件
-- ==============================================================
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
      ".venv",
      "env",
      ".env",
      "node_modules",
      ".angular",
      ".cache",
      ".idea",
      ".vscode",
    },
    -- In case you want to make sure that the score manipulation above works
    -- or if you want to check the score of each file
    debug = {
      scores = false, -- show scores in the list
    },
    -- I like the "ivy" layout, so I set it as the default globaly, you can
    -- still override it in different keymaps
    layout = {
      -- When reaching the bottom of the results in the picker, I don't want
      -- it to cycle and go back to the top
      cycle = false,
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
require("colorizer").setup({
  filetypes = { "css", "scss", "html", "astro" },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue or blue
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = false, -- 0xAARRGGBB hex codes
    rgb_fn = false, -- CSS rgb() and rgba() functions
    hsl_fn = false, -- CSS hsl() and hsla() functions
    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode = "background", -- Set the display mode.Available modes for `mode`: foreground,background,virtualtext
    virtualtext = "■",
    tailwind = true,
  },
})

-- ==============================================================
-- 快捷键统一管理
-- ==============================================================
local foldmethod = require("util.foldmethod")
local markdown = require("util.markdown")
local obsidian = require("util.obsidian")
local snacks_utils = require("util.snacks_utils")
local utils = require("util.utils")
require("which-key").setup({ preset = "modern" })
require("which-key").add({
  { "<leader>b", snacks_utils.find_buffers, desc = "Buffers" },
  { "<leader>e", "<cmd>Oil<CR>", desc = "File Explorer" },
  { "<leader><leader>", "<cmd>e #<CR>", desc = "Switch to Other Buffer" },
  { "<esc>", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
  { "<leader>o", obsidian.open_in_obsidian, mode = "n", desc = "Open in Obsidian" },
  { "<leader>p", '"ap', desc = "Paste from 'a' register" },
  { "<leader>p", '"ap', mode = "v", desc = "Paste from 'a' register" },
  { "<leader>q", "<cmd>:qa<CR>", desc = "Quit Nvim" },
  { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
  { "<leader>x", snacks_utils.bufdelete, desc = "Close buffer" },
  { "<leader>y", "<cmd>let @a = @+<CR>", desc = "Let 'a' register copy from '+' register" },
  { "<leader>y", '"ay', mode = "v", desc = "Copy to 'a' register" },

  -- Run code
  { "<leader>r", snacks_utils.run_file, desc = "Run current Python file in terminal" },
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

  -- Move stuff up and down in visual mode
  { "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move stuff down" },
  { "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move stuff up" },

  -- Better indenting in visual mode
  { ">", ">gv", mode = "v", desc = "Indent right and reselect" },
  { "<", "<gv", mode = "v", desc = "Indent left and reselect" },

  ----------------------
  --     Terminal     --
  ----------------------
  { "<leader>tt", snacks_utils.terminal, desc = "Terminal" },
  { "<leader>to", snacks_utils.terminal_new, desc = "New Terminal" },

  -- Buffers & Tabs
  { "<leader>tc", "<cmd>tabnew<CR>", desc = "New tab" },
  { "<leader>tm", ":tabmove ", desc = "Move tab" },
  { "<leader>tx", "<cmd>tabclose<CR>", desc = "Close tab" },
  { "H", "<cmd>tabprev<CR>", desc = "Tab previous" },
  { "L", "<cmd>tabnext<CR>", desc = "Tab next" },

  ----------------------
  --       lsp       --
  ----------------------
  { "<leader>l", group = "LSP" },
  { "<leader>lD", snacks_utils.find_document_diagnostics, desc = "Document Diagnostics" },
  { "<leader>lR", "<cmd>lsp restart<CR>", desc = "Restart LSP" },
  { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<leader>ld", snacks_utils.find_diagnostics, desc = "Buffer Diagnostics" },
  { "<leader>lf", utils.format_and_save, desc = "Format and save" },
  { "<leader>lg", snacks_utils.lazygit, desc = "LazyGit" },
  { "<leader>lo", "<cmd>Outline<CR>", desc = "Outline" },
  { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },

  ----------------------
  ---    Markdown     --
  ----------------------
  { "<leader>m", group = "Markdown" },
  { "<C-t>", "- [ ] ", mode = "i", desc = "Create a todo in markdown" },
  { "<leader>m2", foldmethod.fold_markdown_headings_2, desc = "Fold all headings level 2-6" },
  { "<leader>m3", foldmethod.fold_markdown_headings_3, desc = "Fold all headings level 3-6" },
  { "<leader>m4", foldmethod.fold_markdown_headings_4, desc = "Fold all headings level 4-6" },
  { "<leader>m5", foldmethod.fold_markdown_headings_5, desc = "Fold all headings level 5-6" },
  { "<leader>m6", foldmethod.fold_markdown_headings_6, desc = "Fold all headings level 6" },
  { "<leader>mT", "<cmd>LspTomorrow<CR>", desc = "Daily Note Tomorrow" },
  { "<leader>mb", markdown.md_text_bold, mode = "v", desc = "Toggle Bold" },
  { "<leader>mc", markdown.md_text_code, mode = "v", desc = "Toggle Inline Code" },
  { "<leader>md", markdown.md_task_toggle, desc = "Mark task toggle" },
  { "<leader>mt", "<cmd>LspToday<CR>", desc = "Daily Note Today" },
  { "<leader>my", "<cmd>LspYesterday<CR>", desc = "Daily Note Yesterday" },

  ----------------------
  --   File Manager   --
  ----------------------
  { "<leader>f", group = "File Manager" },
  { "<leader>fC", snacks_utils.find_commands, desc = "Find commands" },
  { "<leader>fb", snacks_utils.find_buffers, desc = "Buffers" },
  { "<leader>fc", snacks_utils.find_complete_tasks, desc = "Find completed tasks" },
  { "<leader>fe", snacks_utils.explorer, desc = "File Explorer" },
  { "<leader>ff", snacks_utils.find_files, desc = "Find files" },
  { "<leader>fg", snacks_utils.find_git_files, desc = "Find Git Files" },
  { "<leader>fh", snacks_utils.find_help, desc = "Help" },
  { "<leader>fk", snacks_utils.find_keymaps, desc = "Keymaps" },
  { "<leader>fl", snacks_utils.find_links, desc = "Find Links" },
  { "<leader>fq", snacks_utils.find_qflist, desc = "Quickfix" },
  { "<leader>fr", snacks_utils.find_recent, desc = "Recently used files" },
  { "<leader>fs", snacks_utils.find_grep, desc = "Grep" },
  { "<leader>ft", snacks_utils.find_todo_tasks, desc = "Find todo tasks" },
  { "<leader>fw", snacks_utils.find_word, desc = "Find Word" },

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
})
