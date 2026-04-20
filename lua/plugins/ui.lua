return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function()
      vim.cmd([[colorscheme tokyonight]])
      vim.cmd([[highlight Normal guibg=NONE]])
      vim.cmd([[highlight NormalNC guibg=NONE]])
      vim.cmd([[highlight StatusLine guibg=NONE]])
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "filename", path = 1, show_filename_only = false },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.basics").setup()
      require("mini.bufremove").setup()
      require("mini.comment").setup()
      require("mini.pairs").setup()
      require("mini.icons").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      enabled = true,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  },
}
