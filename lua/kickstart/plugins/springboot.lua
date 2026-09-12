return {
  {
    'JavaHello/spring-boot.nvim',
    ft = { 'java', 'yaml', 'jproperties' },
    dependencies = {
      'mfussenegger/nvim-jdtls',
    },
    opts = function()
      local base = vim.fn.stdpath 'data' .. '/mason/packages/vscode-spring-boot-tools/extension/language-server'
      local jars = vim.fn.glob(base .. '/spring-boot-language-server*.jar', false, true)
      local is_windows = vim.fn.has 'win32' == 1
      local win_java = 'C:/Program Files/Java/jdk-21.0.10/bin/java.exe'
      local java_cmd = (is_windows and vim.uv.fs_stat(win_java)) and win_java or (vim.fn.exepath 'java' ~= '' and vim.fn.exepath 'java' or 'java')
      return {
        java_cmd = java_cmd,
        ls_path = jars[1],
      }
    end,
  },
  {
    'elmcgill/springboot-nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-jdtls',
    },
    config = function()
      local springboot_nvim = require 'springboot-nvim'
      vim.keymap.set('n', '<leader>Jr', springboot_nvim.boot_run, { desc = 'Spring Boot Run Project' })
      vim.keymap.set('n', '<leader>Jc', springboot_nvim.generate_class, { desc = 'Java Create Class' })
      vim.keymap.set('n', '<leader>Ji', springboot_nvim.generate_interface, { desc = 'Java Create Interface' })
      vim.keymap.set('n', '<leader>Je', springboot_nvim.generate_enum, { desc = 'Java Create Enum' })
      springboot_nvim.setup {}
    end,
  },
}
