return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = true,
  },
  highlight = {
    multiline = true,
    before = '',
    keyword = 'wide_bg', -- 'fg', 'bg', 'wide', 'wide_bg'
    after = 'fg',
    pattern = [[.*<(KEYWORDS)\s*:]],
  },
}
