

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
