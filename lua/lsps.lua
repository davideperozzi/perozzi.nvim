LSP_SERVERS = {
  volar = {},
  html = {},
  gopls = {},
  svelte = {},
  ["emmet-language-server"] = {},
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
