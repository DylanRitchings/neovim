local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_mac = vim.loop.os_uname().sysname == "Darwin"

ROOT_DIR = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

-- Basic settings
vim.o.timeout = true
vim.o.timeoutlen = 400
vim.opt.clipboard:append("unnamedplus")
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.editorconfig = false

-- Line ending handling: read both formats, default to DOS for new files
vim.o.fileformats = "dos,unix"  -- Can read both CRLF and LF
vim.o.fileformat = "dos"        -- New buffers default to CRLF
vim.o.fixendofline = false      -- Don't add missing end-of-line on save
vim.o.endofline = false         -- Don't add trailing newline at EOF

-- -- Convert Unix line endings to DOS before save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("EnforceFileFormat", { clear = true }),
--   pattern = "*",
--   callback = function(ev)
--     if vim.bo[ev.buf].buftype == "" then
--       -- Get all lines in the buffer
--       local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
--       -- Rewrite them back, which forces any format conversions
--       vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, lines)
--       -- Now set format and EOF flags
--       vim.bo[ev.buf].fileformat = "dos"
--       vim.bo[ev.buf].fixendofline = false
--       vim.bo[ev.buf].endofline = false
--     end
--   end,
-- })

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.wo.conceallevel = 1
vim.g.autoformat = true
vim.opt.mouse = 'a'
vim.g.lazydev_enabled = true

vim.env.GIT_WORK_TREE = vim.fn.getcwd()
vim.env.GIT_DIR = vim.fn.getcwd() .. "/.git"

vim.g.lazyvim_python_lsp = "pyright"


vim.g.loaded_python3_provider = nil

-- Enable line wrapping
vim.wo.wrap = true
vim.o.wrap = true
-- Preserve indentation when wrapping lines
vim.wo.breakindent = true

-- Specify a string to be displayed at the start of wrapped lines
vim.opt.showbreak = ">>"

-- Avoid breaking words when wrapping lines
vim.opt.linebreak = true
vim.o.linebreak = true



-- if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
-- end
if is_windows then
  -- vim.g.python3_host_prog = '/c/Program Files/Python312/python'
  vim.opt.shell = "bash"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellxquote = ""
  vim.opt.shellslash = true
elseif is_mac then
end

vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

-- Make quickfix editable
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('YOUR_GROUP_HERE', { clear = true }),
  desc = 'allow updating quickfix window',
  pattern = 'quickfix',
  callback = function(ctx)
    vim.bo.modifiable = true
    -- :vimgrep's quickfix window display format now includes start and end column (in vim and nvim) so adding 2nd format to match that
    vim.bo.errorformat = '%f|%l col %c| %m,%f|%l col %c-%k| %m'
    vim.keymap.set(
      'n',
      '<C-s>',
      '<Cmd>cgetbuffer|set nomodified|echo "quickfix/location list updated"<CR>',
      { buffer = true, desc = 'Update quickfix/location list with changes made in quickfix window' }
    )
  end,
})
--fix terraform and hcl comment string
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl" },
})

vim.o.termguicolors = true -- Enable 24-bit RGB color
