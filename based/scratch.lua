local NVIM_DIR = vim.fn.expand("~/.config/nvim")

local DEFAULT_SPECS = {
    ['oil.nvim'] = { src = gh("stevearc/oil.nvim") },
    ['blink.cmp'] = { src = gh("saghen/blink.cmp") },
}

local M = {}

M.gh = function(id)
    return "https://github.com/" .. id
end

M.gl = function(id)
    return "https://gitlab.com/" .. id
end

M.cb = function(id)
    return "https://codeberg.org/" .. id
end

M.create_spec_list = function(is_nix)
    local specs = {}
    if is_nix then
        local lookup_file = NVIM_DIR .. "/plugin-locations.lua"
        local plugin_locations = dofile(lookup_file)
        for name, _ in pairs(DEFAULT_SPECS) do
            if plugin_locations[name] then
                specs[name] = { src = "file://" .. plugin_locations[name].path }
            else
                print("Plugin " .. name .. " not installed via Nix!")
                specs[name] = { src = DEFAULT_SPECS[name].src }
            end
        end
    else
        for name, info in pairs(DEFAULT_SPECS) do
            specs[name] = { src = info.src }
        end
    end
    return specs
end

return M

--------------


is_nix = vim.uv.fs_stat("/nix/store") ~= nil
local helpers = M

local nix_paths = helpers.create_spec_list(is_nix)

if is_nix then
    local ts_path = nix_paths["nvim-treesitter/nvim-treesitter"].path
    vim.opt.runtimepath:append(ts_path)
end

require('nvim-treesitter.configs').setup({
    ensure_installed = is_nix and {} or { "lua", "python", "rust", "typescript", "haskell" },
    highlight = { enable = true },
    parser_install_dir = not has_nix and vim.fn.stdpath("data") .. "/parsers" or nil,
})


vim.keymap.set('n', '<leader>lu', function()
    -- Create a new empty floating window or split
    vim.cmd('vsplit | enew')
    vim.bo.filetype = 'lua'
    vim.bo.bufhidden = 'hide'
    
    -- Map <CR> to execute the current line or selection
    vim.keymap.set('n', '<CR>', ':.lua<CR>', { buffer = true })
    vim.keymap.set('v', '<CR>', ':lua<CR>', { buffer = true })
end, { desc = "Open Lua Scratchpad" })


--------- old implementation

local has_nix, nix_plugins = pcall(require, "nix_plugins")

---@param id string The key in the nix_plugins table (e.g., "oil-nvim")
---@param github_src string Fallback GitHub URL
local function get_spec(id, github_src)
    local dev_path = vim.fn.expand("~/repos/" .. id)
    if vim.uv.fs_stat(dev_path) then
        return { path = dev_path }
    end

    if has_nix and nix_plugins[id] then
        return { path = nix_plugins[id] }
    end

    return { src = github_src }
end


--------- oldest sketch

local M = {}

-- Detect if we are on a Nix-managed system
-- We check for a specific environment variable or the /nix/store directory
M.is_nix = vim.uv.fs_stat("/nix/store") ~= nil

---@param name string The plugin folder name (e.g., "oil.nvim")
---@param repo string The GitHub shorthand (e.g., "stevearc/oil.nvim")
---@return table
function M.plug(name, repo)
    if M.is_nix then
        -- On Nix, we assume the plugin is already provided in the packpath
        -- or available in a specific local directory managed by Nix.
        -- Adjust "/etc/profiles/per-user/$USER/share/nvim/site/..." if needed.
        local nix_path = vim.fn.expand("~/.nix-profile/share/nvim/site/pack/dist/start/" .. name)
        
        if vim.uv.fs_stat(nix_path) then
            return { path = nix_path }
        end
    end

    -- Fallback for Git: use the remote URI
    return { src = "https://github.com/" .. repo }
end

-- Example Usage:
vim.pack.add({
    M.plug("oil.nvim", "stevearc/oil.nvim"),
    M.plug("blink.cmp", "saghen/blink.cmp"),
    M.plug("rustaceanvim", "mrcjkb/rustaceanvim"),
})
