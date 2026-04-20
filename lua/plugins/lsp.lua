return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      -- Recommended coc.nvim keybindings
      vim.keymap.set("n", "[g", '<Plug>(coc-diagnostic-prev)', { desc = "Go to previous diagnostic" })
      vim.keymap.set("n", "]g", '<Plug>(coc-diagnostic-next)', { desc = "Go to next diagnostic" })
      -- Only set coc.nvim keybindings for diagnostics, keep LSP for navigation/actions
      -- Unified coc.nvim keybindings and settings
      vim.keymap.set("n", "gD", ':call CocActionAsync("jumpDeclaration")<CR>', { desc = "Go to declaration" })
      vim.keymap.set("n", "gd", '<Plug>(coc-definition)', { desc = "Go to definition" })
      vim.keymap.set("n", "gi", '<Plug>(coc-implementation)', { desc = "Go to implementation" })
      vim.keymap.set("n", "gt", '<Plug>(coc-type-definition)', { desc = "Go to type definition" })
      vim.keymap.set("n", "gr", '<Plug>(coc-references)', { desc = "Find references" })
      vim.keymap.set("n", "gR", '<Plug>(coc-rename)', { desc = "Rename symbol" })
      vim.keymap.set("n", "gf", ':call CocActionAsync("format")<CR>', { desc = "Format buffer" })
      vim.keymap.set("n", "ga", ':CocAction<CR>', { desc = "Code action" })
      vim.keymap.set("n", "gh", ':call CocActionAsync("doHover")<CR>', { desc = "Hover documentation" })
      vim.keymap.set("n", "gs", ':call CocActionAsync("showSignatureHelp")<CR>', { desc = "Signature help" })
      vim.keymap.set("n", "gk", '<Plug>(coc-diagnostic-info)', { desc = "Show diagnostics" })
      vim.keymap.set("n", "gn", '<Plug>(coc-diagnostic-next)', { desc = "Next diagnostic" })
      vim.keymap.set("n", "gp", '<Plug>(coc-diagnostic-prev)', { desc = "Previous diagnostic" })
      vim.keymap.set("n", "gb", function()
        vim.cmd('normal! <C-o>')
      end, { desc = "Go back to previous location" })
      vim.cmd [[
        inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
      ]]
      vim.keymap.set("n", "g<Space>", 'coc#refresh()', { expr = true, silent = true, desc = "Trigger completion" })
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = "*",
      --   callback = function()
      --     vim.cmd("CocActionAsync('format')")
      --   end,
      -- })
      -- Basic config: show documentation on hover
      --   vim.cmd [[
      --     autocmd CursorHold * silent call CocActionAsync('doHover')
      --     autocmd User CocNvimInit ++once :CocInstall -sync coc-pyright coc-json coc-tsserver coc-lua coc-bash coc-yaml coc-html coc-css coc-markdown coc-powershell coc-docker coc-terraform coc-sql coc-vim | q
      --   ]]
    end,
  },
  "yaegassy/coc-cucumber",
  "folke/neodev.nvim",
  "jonatan-branting/nvim-better-n",
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    event = "CmdlineEnter",
    opts = function(_, opts)
      local ok, cmp = pcall(require, "cmp")
      if not ok then
        return opts
      end

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      return opts
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "v1.32.0"
  },
}
