local M = {}

local function parse_maven_error(line)
  -- Maven/javac:
  -- [ERROR] /D:/path/File.java:[82,19] cannot find symbol
  --
  -- Also handles:
  -- /D:/path/File.java:[82,19]

  local path, line_number, column = line:match '%[ERROR%]%s+(.-):%[(%d+),(%d+)%]'

  if not path then
    path, line_number, column = line:match '(.-):%[(%d+),(%d+)%]'
  end

  if not path then
    return nil
  end

  return {
    path = path,
    line = tonumber(line_number),
    column = tonumber(column),
  }
end

local function normalize_windows_path(path)
  -- Maven under Windows may produce:
  --
  -- /D:/Projects/...
  --
  -- Convert it to:
  --
  -- D:/Projects/...

  path = path:gsub('^/', '')

  return path
end

function M.jump_to_current_error()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- First try the line under the cursor.
  local diagnostic = parse_maven_error(lines[current_line])

  -- If the cursor is on a continuation line, search upward
  -- for the Maven diagnostic that owns it.
  if not diagnostic then
    for line_number = current_line - 1, 1, -1 do
      diagnostic = parse_maven_error(lines[line_number])

      if diagnostic then
        break
      end
    end
  end

  if not diagnostic then
    vim.notify('No compiler error found here', vim.log.levels.WARN)
    return
  end

  local path = normalize_windows_path(diagnostic.path)

  -- Expand relative paths if necessary.
  if not path:match '^%a:[/\\]' and not path:match '^[/\\]' then
    path = vim.fn.getcwd() .. '/' .. path
  end

  path = vim.fn.fnamemodify(path, ':p')

  -- Verify the source file exists before leaving the terminal.
  if vim.fn.filereadable(path) ~= 1 then
    vim.notify('Compiler file not found: ' .. path, vim.log.levels.ERROR)
    return
  end

  -- Open the source file.
  vim.cmd('edit ' .. vim.fn.fnameescape(path))

  -- Compiler columns are 1-based.
  -- Neovim's byte column is 0-based.
  vim.api.nvim_win_set_cursor(0, {
    diagnostic.line,
    math.max(diagnostic.column - 1, 0),
  })

  -- Center the cursor.
  vim.cmd 'normal! zz'
end

return M
