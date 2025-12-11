-- Snacks is already loaded by default but for some reason zen code mode is not, so I'm adding it here.
return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    zen = { enabled = true },
  },
}
