local ls = require("luasnip")

local snip = ls.snippet
local text = ls.text_node

---------------------------- Snippets  ------------------------------------------------
local snippets = {
	snip("todo", text("console.log('TODO')")),
	snip("stack", text("serverless stack")),
}

return snippets
