return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    require('mini.align').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local filename = MiniStatusline.section_filename { trunc_width = 140 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local location = MiniStatusline.section_location { trunc_width = 75 }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics, lsp } },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = 'MiniStatuslineLocation', strings = { location } },
          }
        end,
      },
    }

    local c = require('tokyonight.colors').setup()

    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = c.bg, bg = c.blue, bold = true })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = c.bg, bg = c.green, bold = true })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = c.bg, bg = c.magenta, bold = true })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = c.bg, bg = c.red, bold = true })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = c.bg, bg = c.yellow, bold = true })

    vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = c.fg, bg = c.bg_statusline })
    vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = c.cyan, bg = c.bg_statusline })
    vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = c.orange, bg = c.bg_statusline })
    vim.api.nvim_set_hl(0, 'MiniStatuslineLocation', { fg = c.purple, bg = c.bg_statusline })

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    -- statusline.section_location = function()
    --   return '%2l:%-2v'
    -- end
  end,
}
