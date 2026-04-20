return {
  "folke/lazy.nvim",
  "nvim-tree/nvim-web-devicons",
  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },
  {
    "Piotr1215/presenterm.nvim",
    build = false,
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "ahmedkhalf/project.nvim" },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "FileType qf",
  },
}
