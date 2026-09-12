return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    local java_cmds = vim.api.nvim_create_augroup('kickstart_jdtls', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      group = java_cmds,
      callback = function(args)
        local jdtls = require 'jdtls'
        local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
        local root_dir = require('jdtls.setup').find_root(root_markers)
        if not root_dir or root_dir == '' then
          root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))
        end

        local project_name = vim.fs.basename(root_dir)
        local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. (project_name or 'default')

        local is_windows = vim.fn.has 'win32' == 1
        local java21_home = is_windows and 'C:/Program Files/Java/jdk-21.0.10' or (vim.env.JAVA_HOME or '')
        if java21_home ~= '' and vim.uv.fs_stat(java21_home) then
          vim.env.JAVA_HOME = java21_home
        end

        -- Mason jdtls executable
        local jdtls_bin = vim.fn.exepath 'jdtls'
        if jdtls_bin == '' then
          local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/jdtls'
          jdtls_bin = is_windows and (mason_bin .. '.cmd') or mason_bin
        end

        -- Lombok support
        local cmd = { jdtls_bin }
        local java_bin = is_windows and (java21_home .. '/bin/java.exe') or (java21_home ~= '' and (java21_home .. '/bin/java') or vim.fn.exepath 'java')
        if java_bin ~= '' and vim.uv.fs_stat(java_bin) then
          table.insert(cmd, '--java-executable')
          table.insert(cmd, java_bin)
        end

        local has_mason, mason_registry = pcall(require, 'mason-registry')
        if has_mason and mason_registry.is_installed 'jdtls' then
          local lombok = mason_registry.get_package('jdtls'):get_install_path() .. '/lombok.jar'
          if vim.uv.fs_stat(lombok) then
            table.insert(cmd, string.format('--jvm-arg=-javaagent:%s', lombok))
          end
        end

        table.insert(cmd, '-data')
        table.insert(cmd, workspace_dir)

        -- Completion capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
        if has_cmp then
          capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
        end

        -- Bundles (e.g. spring boot jdtls extensions)
        local bundles = {}
        local has_sb, spring_boot = pcall(require, 'spring_boot')
        if has_sb then
          vim.list_extend(bundles, spring_boot.java_extensions())
        end

        local config = {
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities,
          init_options = {
            bundles = bundles,
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
          },
          settings = {
            java = {
              signatureHelp = { enabled = true },
              contentProvider = { preferred = 'fernflower' },
              completion = {
                favoriteStaticMembers = {
                  'org.hamcrest.MatcherAssert.assertThat',
                  'org.hamcrest.Matchers.*',
                  'org.hamcrest.CoreMatchers.*',
                  'org.junit.jupiter.api.Assertions.*',
                  'java.util.Objects.requireNonNull',
                  'java.util.Objects.requireNonNullElse',
                  'org.mockito.Mockito.*',
                },
                filteredTypes = {
                  'com.sun.*',
                  'io.micrometer.shaded.*',
                  'java.awt.*',
                  'jdk.*',
                  'sun.*',
                },
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                },
                useBlocks = true,
              },
              configuration = {
                updateBuildConfiguration = 'interactive',
                runtimes = vim.tbl_filter(function(r)
                  return vim.uv.fs_stat(r.path) ~= nil
                end, {
                  {
                    name = 'JavaSE-17',
                    path = is_windows and 'C:/Program Files/Java/jdk-17' or '/usr/lib/jvm/java-17-openjdk',
                  },
                  {
                    name = 'JavaSE-21',
                    path = is_windows and 'C:/Program Files/Java/jdk-21.0.10' or '/usr/lib/jvm/java-21-openjdk',
                    default = true,
                  },
                }),
              },
            },
          },
        }

        -- Java-specific buffer keymaps
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = 'Java: ' .. desc })
        end

        map('n', '<leader>jo', jdtls.organize_imports, 'Organize Imports')
        map('n', '<leader>jv', jdtls.extract_variable, 'Extract Variable')
        map('v', '<leader>jv', [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], 'Extract Variable')
        map('n', '<leader>jc', jdtls.extract_constant, 'Extract Constant')
        map('v', '<leader>jc', [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], 'Extract Constant')
        map('v', '<leader>jm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], 'Extract Method')
        map('n', '<leader>jt', jdtls.test_nearest_method, 'Test Nearest Method')
        map('n', '<leader>jT', jdtls.test_class, 'Test Class')

        jdtls.start_or_attach(config)
      end,
    })
  end,
}
