return {
  "tpope/vim-fugitive",
  lazy = true,            -- Lazy-load if desired
  cmd = { "G", "Git", "Gclog" }, -- Load on Fugitive commands
  config = function()
    -- Optional: global Fugitive config can go here
    -- For example, automatically open quickfix when using Glog
    vim.g.fugitive_quickfix_autojump = 1
  end,
}
