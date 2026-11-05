-- Register before vim.pack.add() so the first installation is covered too.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UserTreesitterUpdate", { clear = true }),
  callback = function(ev)
    local data = ev.data
    if data.spec.name ~= "nvim-treesitter" or (data.kind ~= "install" and data.kind ~= "update") then
      return
    end

    if not data.active then
      vim.cmd.packadd("nvim-treesitter")
    end
    -- Equivalent to :TSUpdate: refresh all installed parsers, not just missing ones.
    require("nvim-treesitter").update(nil, { summary = true })
  end,
})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

local ensure_installed = {
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
  "svelte",
  "gdscript",
}
-- Normal startup only installs missing parsers; updates run via PackChanged.
require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype

    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    local ok_add = pcall(vim.treesitter.language.add, lang)
    if not ok_add then
      return
    end

    pcall(vim.treesitter.start, buf, lang)
  end,
})
