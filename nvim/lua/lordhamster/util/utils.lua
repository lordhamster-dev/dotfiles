local M = {}

function M.format()
  require("conform").format({ async = true }, function(err, did_edit)
    vim.notify(err or (did_edit and "Formatted buffer" or "Buffer already formatted"), vim.log.levels.INFO)
  end)
end

function M.format_and_save()
  require("conform").format({ async = true }, function(err, did_edit)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end

    -- Save the buffer after formatting
    vim.cmd("write")
    vim.notify(did_edit and "Formatted and saved buffer" or "Buffer already formatted, saved", vim.log.levels.INFO)
  end)
end

return M
