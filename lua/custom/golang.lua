-- Format go source file. Log errors
vim.keymap.set("n", "gf", function()
  -- Check if 'gopls' is active
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local has_gopls = false

  for _, client in ipairs(clients) do
    if client.name == "gopls" then
      has_gopls = true
      break
    end
  end

  if not has_gopls then
    vim.notify("gopls is not active", vim.log.levels.WARN)
    return
  end

  -- Save current buffer lines and cursor position
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = table.concat(lines, "\n")
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Run 'gofmt' and capture output
  local output = vim.fn.system("gofmt", input)

  -- Check if 'gofmt' succeeded
  if vim.v.shell_error ~= 0 then
    vim.notify("gofmt failed:\n" .. output, vim.log.levels.WARN)
    return
  end

  -- Replace buffer content with formatted output
  local formatted = vim.split(output, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)

  -- Restore cursor position
  local new_line_count = #formatted
  local old_line_count = #lines
  local line_diff = new_line_count - old_line_count
  local new_row = math.max(1, cursor_pos[1] + line_diff)
  vim.api.nvim_win_set_cursor(0, { new_row, cursor_pos[2] })
end, { noremap = true, silent = true })

-- Organize imports before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    if not result then return end

    for _, res in pairs(result) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
        elseif action.command then
          vim.lsp.buf.execute_command(action.command)
        end
      end
    end
  end,
})
