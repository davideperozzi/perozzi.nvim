-- Default Globals
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

-- Default Options
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.relativenumber = true;
vim.opt.hlsearch = false

-- Basic Keymappings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set("n", "gf", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local old_line_count = vim.api.nvim_buf_line_count(0)

  vim.cmd("silent! %!gofmt")

  local new_line_count = vim.api.nvim_buf_line_count(0)
  local line_diff = new_line_count - old_line_count
  local new_row = math.max(1, cursor_pos[1] + line_diff)

  vim.api.nvim_win_set_cursor(0, { new_row, cursor_pos[2] })
end, { noremap = true, silent = true })

-- Auto CMDs
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" }, diagnostics = {} },
      apply = true

    })
  end
})

-- All LSPs
LSP_SERVERS = {
  volar = {},
  html = {},
  gopls = {},
  -- denols = {},
  ts_ls = {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>ro', function()
        vim.lsp.buf.execute_command({
          command = "_typescript.organizeImports",
          arguments = { vim.fn.expand("%:p") }
        })
      end, { buffer = bufnr, remap = false });
    end,
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = "/Users/davideperozzi/.bun/bin/vue-language-server",
          languages = { "vue" },
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        completion = { callSnippet = 'Replace' },
        diagnostics = {
          globals = { 'vim' }
        }
      },
    }
  },
}

-- Include lazy.nvim
require("config.lazy")
