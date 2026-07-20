return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 30,
        side = 'right',
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      git = {
        enable = false,
      },
      diagnostics = {
        enable = false,
      },
    }
    vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { desc = 'toggle side tree' })
  end,
}
