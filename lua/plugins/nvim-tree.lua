return {
  "nvim-tree/nvim-tree.lua",
  version = "1.11.x",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      filters = { dotfiles = true }
    })

    vim.keymap.set("n", "<C-b>", ':NvimTreeToggle<CR><Esc>', { noremap = true })
  end,
}
