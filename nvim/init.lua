-- vim.opt.rtp:prepend("/nix/store/9af9rww8nnrpfpjhz1sk8yg27q049rby-vimplugin-nvim-treesitter-2025-05-24")
-- require('nvim-treesitter')
-- require'nvim-treesitter.configs'.setup {
--     -- ensure_installed = { "python", "lua", "javascript" },  -- Ensure installed parsers
--    highlight = { enable = true },
--     fold = { enable = false }  -- Disable folding if necessary
--  }

function addRelPath(dir)
    local spath =
        debug.getinfo(1,'S').source
          :sub(2)
          :gsub("^([^/])","./%1")
          :gsub("[^/]*$","")
    dir=dir and (dir.."/") or ""
    spath = spath..dir
    package.path = spath.."?.lua;"
                 ..spath.."?/init.lua"
                --  ..package.path
end


addRelPath()
require("_colors")
-- require("commands")
-- require("mappings")
-- require("options")

-- require("features.file_browser_tree")
-- require("features.status_line")

require("python")
-- require("languages.xit")

