vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
})

-- Pack Delete and Update cmds are built-in on Nightly 0.13
vim.api.nvim_create_user_command("PackDel", function(opts)
  vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  -- checks if any argument is passed
  if opts.args:match("%S") then
    -- update specific plugins
    local plugins = vim.split(opts.args, "%s+", { trimempty = true })
    -- update only specified plugins
    vim.pack.update(plugins)
  else
    -- update all
    vim.pack.update()
  end
end, { nargs = "*", desc = "Update all plugins or specific ones" })
