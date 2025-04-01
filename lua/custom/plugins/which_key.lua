return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  -- event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    require('which-key').add {
      { '<leader>b', group = '[b]uffer' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]ession' },
      { '<leader>f', group = '[F]ind' },
      { '<leader>l', group = '[L]sp' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>p', group = '[P]ackage management' },
      { '<leader>c', group = '[C]ode runner' },
    }
  end,
}
