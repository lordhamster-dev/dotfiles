local configured = false

local function load()
  if configured then
    return require("render-markdown")
  end

  configured = true
  vim.pack.add({
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  })

  return require("render-markdown")
end

-- 打开 markdown 文件时自动加载 render-markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = load,
})
