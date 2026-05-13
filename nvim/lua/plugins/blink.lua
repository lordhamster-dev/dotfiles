vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

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
