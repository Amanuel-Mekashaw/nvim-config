return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'vim',
        'vimdoc',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      pcall(function()
        require('treesitter-context').setup {
          on_attach = function(buf)
            return not vim.tbl_contains({ 'markdown', 'mdx', 'pandoc' }, vim.bo[buf].filetype)
          end,
        }
      end)
      vim.api.nvim_set_hl(0, 'markdownError', { link = 'Normal' })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
  },
}
