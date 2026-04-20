return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gclog" },
    keys = {
      { "<leader>gs", ":Git<CR>",                           desc = "Git status" },
      { "<leader>gc", ":Git commit -a<CR>",                 desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<CR>",                  desc = "Push" },
      { "<leader>gP", "<cmd>Git pull<CR>",                  desc = "Pull" },
      { "<leader>gf", "<cmd>Git fetch<CR>",                 desc = "Fetch" },
      { "<leader>gb", "<cmd>Git branch<CR>",                desc = "Branch" },
      { "<leader>gB", "<cmd>Git blame<CR>",                 desc = "Blame" },
      { "<leader>gL", "<cmd>Git log<CR>",                   desc = "Log" },
      { "<leader>gr", "<cmd>Git rebase<CR>",                desc = "Rebase" },
      { "<leader>gd", "<cmd>Git diff<CR>",                  desc = "Diff" },
      { "<leader>gD", "<cmd>Git diff origin/main -- %<CR>", desc = "Diff with origin/main" },
      { "<leader>gS", "<cmd>Git stash<CR>",                 desc = "Stash" },
      { "<leader>gm", "<cmd>Git merge<CR>",                 desc = "Merge" },
      { "<leader>gC", "<cmd>Git cherry-pick<CR>",           desc = "Cherry Pick" },
    },
    config = function()
      vim.g.fugitive_quickfix_autojump = 1
    end,
  },
  {
    "airblade/vim-gitgutter",
    event = "BufReadPre",
    config = function()
      -- Configure vim-gitgutter here if needed.
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <author> • <summary> • <date>",
      date_format = "%d-%m-%Y %H:%M:%S",
      virtual_text_coklumn = 1,
    },
  },
}
