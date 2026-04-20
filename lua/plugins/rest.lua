return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
    },
    config = function(_, opts)
      require("kulala").setup(opts)

      vim.keymap.set("n", "<leader>rr", function() require("kulala").run() end, { desc = "run HTTP request" })
      vim.keymap.set("n", "<leader>rl", function() require("kulala").replay() end, { desc = "run last HTTP request" })
      vim.keymap.set("n", "<leader>rn", function() require("kulala").jump_next() end, { desc = "next HTTP request" })
      vim.keymap.set("n", "<leader>rp", function() require("kulala").jump_prev() end, { desc = "prev HTTP request" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "http", "json" })
    end,
  },
}