local ls = require("luasnip")
local partial = require("luasnip.extras").partial
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node

---------------------------- Snippets  ------------------------------------------------
local snippets = {
	-- snip({
	-- 	trig = "frontmatter",
	-- 	namr = "Frontmatter",
	-- 	dscr = "Yaml format for markdown",
	-- }, {
	-- 	text({ "---", "title: " }),
	-- 	insert(1, ""),
	-- 	text({ "", "author: " }),
	-- 	insert(2, "author"),
	-- 	text({ "", "date: " }),
	-- 	func(date, {}),
	-- 	text({ "", "categories: [" }),
	-- 	insert(3, ""),
	-- 	text({ "]", "lastmod: " }),
	-- 	func(date, {}),
	-- 	text({ "", "tags: [" }),
	-- 	insert(4),
	-- 	text({ "]", "comments: true", "---", "" }),
	-- 	insert(0),
	-- }),

	snip("date", partial(os.date, "%Y-%m-%d")),

	snip("yy", partial(os.date, "%Y")),

	snip("url_link", {
		text('<a href="'),
		func(function(_, s)
			-- TM_SELECTED_TEXT is a table to account for multiline-selections.
			-- In this case only the first line is inserted.
			return s.env.TM_SELECTED_TEXT[1] or {}
		end, {}),
		text('">'),
		insert(1),
		text("</a>"),
		insert(0),
	}),

	snip("mlink", {
		text("["),
		insert(1),
		text("]("),
		func(function(_, s)
			return s.env.TM_SELECTED_TEXT[1] or {}
		end, {}),
		text(")"),
		insert(0),
	}),
}

return snippets -- , autosnippets
