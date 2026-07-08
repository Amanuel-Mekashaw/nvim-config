return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    local set = vim.keymap.set

    -- Add cursor below/above
    set({ 'n', 'v' }, '<S-j>', function()
      mc.lineAddCursor(1)
    end, { desc = 'Add cursor below' })

    set({ 'n', 'v' }, '<S-k>', function()
      mc.lineAddCursor(-1)
    end, { desc = 'Add cursor above' })

    -- Add next occurrence
    set('n', '<C-A-d>', function()
      mc.matchAddCursor(1)
    end, { desc = 'Add next occurrence' })

    -- Add previous occurrence
    set('n', '<C-S-d>', function()
      mc.matchAddCursor(-1)
    end, { desc = 'Add previous occurrence' })

    -- Skip current occurrence
    set('n', '<C-x>', function()
      mc.matchSkipCursor(1)
    end, { desc = 'Skip occurrence' })

    -- Select all matches
    set('n', '<leader>ma', mc.matchAllAddCursors, {
      desc = 'Select all matches',
    })

    -- Delete current cursor
    set('n', '<leader>md', mc.deleteCursor, {
      desc = 'Delete cursor',
    })

    -- Enable/disable multicursor mode
    set('n', '<leader>mm', mc.toggleCursor, {
      desc = 'Toggle cursor',
    })
  end,
}
