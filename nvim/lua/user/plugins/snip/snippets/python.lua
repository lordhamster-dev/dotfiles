local ls = require("luasnip")
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

-- create the actual snippet
local snippets = {
	snip("env", {
		text({ "#!/usr/bin/env python", "" }),
		insert(0),
	}),
	snip("ti", {
		text({ "# type: ignore" }),
		insert(0),
	}),
}

return snippets
