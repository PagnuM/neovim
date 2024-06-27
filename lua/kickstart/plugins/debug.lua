-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = false,
      automatic_setup = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'js-debug-adapter',
      },
    }
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    ---@param keybinds string[]
    ---@param fn string|function
    ---@param desc string
    local multi_map = function(keybinds, fn, desc)
      for _, key in ipairs(keybinds) do
        vim.keymap.set('n', key, fn, { desc = desc })
      end
    end

    multi_map({ '<F5>', '<leader>dc' }, dap.continue, 'Debug: Start/Continue')
    multi_map({ '<F6>', '<leader>dp' }, dap.pause, 'Debug: Pause')
    multi_map({ '<C-F5>', '<leader>dr' }, dap.restart, 'Debug: Restart')

    multi_map({ '<F11>', '<leader>di' }, dap.step_into, 'Debug: Step Into')
    multi_map({ '<F10>', '<leader>do' }, dap.step_over, 'Debug: Step Over')
    multi_map({ '<S-F11>', '<leader>dO' }, dap.step_out, 'Debug: Step Out')

    vim.keymap.set('n', '<leader>dB', dap.clear_breakpoints, { desc = 'Debug: Clear Breakpoints' })
    multi_map({ '<F9>', '<leader>db' }, dap.toggle_breakpoint, 'Debug: Toggle Breakpoint')
    multi_map({ '<S-F9>', '<leader>dC' }, function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, 'Debug: Set Breakpoint')

    vim.keymap.set('n', '<leader>ds', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
    vim.keymap.set('n', '<leader>dq', dap.close, { desc = 'Debug: Close session' })
    multi_map({ '<S-F5>', '<leader>dQ' }, dap.terminate, 'Debug: Terminate session')

    vim.keymap.set('n', '<leader>dR', dap.repl.toggle, { desc = 'Debug: Close session' })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })

    vim.keymap.set('n', '<leader>dE', function()
      vim.ui.input({ prompt = 'Expression: ' }, function(expr)
        if expr then
          require('dapui').eval(expr, { enter = true })
        end
      end)
    end, { desc = 'Debug: Evaluate Expression' })

    -- Install golang specific config
    require('dap-go').setup()

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = 8123,
      executable = {
        command = 'js-debug-adapter',
      },
    }

    for _, language in ipairs { 'typescript', 'javascript' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
      }
    end
  end,
}
