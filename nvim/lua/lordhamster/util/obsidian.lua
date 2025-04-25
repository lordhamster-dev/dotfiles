-- Obsidian integration utilities
-- Features:
-- 1. Open current file in Obsidian with proper vault and path format
-- 2. Removes file extensions
-- 3. Uses relative paths within the vault

local M = {}

-- Configuration
M.config = {
  vault_name = "LordHamster",
  vault_path = "~/Sync/Obsidian/LordHamster", -- Default vault path
}

-- Setup function for configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Open current file in Obsidian with proper vault and path format
function M.open_in_obsidian()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then
    vim.notify("No file is currently open", vim.log.levels.WARN)
    return
  end

  -- Get absolute path of vault and current file
  local vault_path = vim.fn.expand(M.config.vault_path)
  local abs_file_path = vim.fn.fnamemodify(file_path, ":p")

  -- Check if file is within vault directory
  if not string.find(abs_file_path, vault_path, 1, true) then
    vim.notify("File is not within the configured Obsidian vault", vim.log.levels.WARN)
    return
  end

  -- Get relative path from vault root
  local relative_path = string.sub(abs_file_path, #vault_path + 2)

  -- Remove file extension
  relative_path = vim.fn.fnamemodify(relative_path, ":r")

  -- URL encode path and construct URI
  local encoded_path = vim.fn.fnameescape(relative_path):gsub("\\", "%%")
  local uri = "obsidian://open?vault=" .. M.config.vault_name .. "&file=" .. encoded_path

  -- Open URI (works on macOS, Linux, Windows)
  if vim.fn.has("mac") == 1 then
    os.execute('open "' .. uri .. '"')
  elseif vim.fn.has("unix") == 1 then
    os.execute('xdg-open "' .. uri .. '"')
  else
    vim.notify("Unsupported platform for Obsidian integration", vim.log.levels.ERROR)
  end
end

return M
