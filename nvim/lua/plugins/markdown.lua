local M = {}

local configured = false

function M.load()
  if configured then
    return require("render-markdown")
  end

  vim.pack.add({
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  })

  configured = true
  return require("render-markdown")
end

-- 打开 markdown 文件时自动加载 render-markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = M.load,
})

return M
