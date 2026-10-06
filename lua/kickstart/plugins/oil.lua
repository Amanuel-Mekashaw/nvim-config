return {
  'stevearc/oil.nvim',
  opts = {},

  dependencies = {
    { 'nvim-mini/mini.icons', opts = {} },
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    require('oil').setup {
      default_file_explorer = true,
      columns = {
        'icon',
        -- 'size',
      },
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },

      skip_confirm_for_simple_edits = false,
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
      vim.keymap.set('n', '<leader>-', require('oil').toggle_float),
    }
  end,
  lazy = false,
}
