-- return {}
-- return { -- Highlight, edit, and navigate code
--   'nvim-treesitter/nvim-treesitter',
--   build = ':TSUpdate',
--   main = 'nvim-treesitter.configs', -- Sets main module to use for opts
--   branch = 'main',
--   lazy = false,
--
--   opts = {
--     fold = { enable = true },
--     ensure_installed = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
--     auto_install = true,
--     highlight = {
--       enable = true,
--     },
--   },
-- }

local M = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
  },
  branch = 'master',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.install {
      'c',
      'cpp',
      'glsl',
      'lua',
      'meson',
      'python',
      'vim',
      'vimdoc',
      'query',
    }
  end,
}

return { M }
