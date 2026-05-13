vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

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
