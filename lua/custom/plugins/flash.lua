return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    highlight = {
      backdrop = false,
    },
    modes = {
      char = {
        highlight = {
          backdrop = false,
        },
      },
    },
    prompt = {
      enabled = false,
    },
  },
  -- stylua: ignore
  keys = {
    { "ñ", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  },
  config = function()
    require('flash').toggle(false)
  end,
}
