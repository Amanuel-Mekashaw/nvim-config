return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', -- for telescope integration
  },
  config = function()
    local harpoon = require 'harpoon'

    -- Set up harpoon with persistence and sync settings
    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd() -- Use current working directory for context
        end,
      },
    }

    -- Normal Harpoon keymaps
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Add file' })

    vim.keymap.set('n', '<C-x>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle quick menu' })

    -- Optional: Quick nav to first 4 files (feel free to extend this)
    vim.keymap.set('n', '<A-1>', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon: Go to file 1' })

    vim.keymap.set('n', '<A-2', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon: Go to file 2' })

    vim.keymap.set('n', '<A-3>', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon: Go to file 3' })

    vim.keymap.set('n', '<A-4>', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon: Go to file 4' })

    -- Telescope integration
    require('telescope').load_extension 'harpoon'

    vim.keymap.set('n', '<leader>sh', function()
      require('telescope').extensions.harpoon.marks()
    end, { desc = 'Telescope: Harpoon marks' })
  end,
}
