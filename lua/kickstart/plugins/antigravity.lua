return {
  'Showwaiyan/antigravity.nvim',
  opts = {
    cmd = 'agy',
  },
  keys = {
    { '<leader>aa', '<cmd>AntigravityAsk<cr>', desc = 'Ask Antigravity' },
    { '<leader>aa', ':AntigravityAsk ', mode = 'v', desc = 'Ask Antigravity (Selection)' },
    { '<leader>as', '<cmd>AntigravitySelect<cr>', desc = 'Select Antigravity Preset' },
    { '<leader>as', ':AntigravitySelect<cr>', mode = 'v', desc = 'Select Antigravity Preset (Selection)' },
    { '<leader>at', '<cmd>AntigravityToggle<cr>', desc = 'Toggle Antigravity Split' },
  },
}
