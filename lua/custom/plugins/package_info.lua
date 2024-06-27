return {
  'vuki656/package-info.nvim',
  opts = {
    colors = {
      up_to_date = '#3C4048', -- Text color for up to date dependency virtual text
      outdated = '#d19a66', -- Text color for outdated dependency virtual text
    },
    icons = {
      enable = true, -- Whether to display icons
      style = {
        up_to_date = '|  ', -- Icon for up to date dependencies
        outdated = '|  ', -- Icon for outdated dependencies
      },
    },
    autostart = true, -- Whether to autostart when `package.json` is opened
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('package-info').setup()
  end,
}
