vim.g.mapleader = " "
-- local function safe_require(module)
--   local status, err = pcall(require, module)
--   if not status then
--     print("Error loading module: " .. module .. "\n" .. err)
--   end
-- end

require("config.lazy")


require("config.settings")

require("lazy").setup("plugins")


require("lualine").setup()

require("config.bindings")

require("config.ts_utils")
-- require("config.utils")

