With Neovim 0.12's `vim.pack.add()`, you can achieve lazy loading without a plugin manager by manually calling `vim.pack.add()` at the appropriate times. Here's how:

## Basic approach:

```lua
-- In your init.lua

-- Don't load these at startup - just declare them
local lazy_plugins = {
    oil = { name = "oil.nvim", dir = "/nix/store/.../oil.nvim" },
    blink = { name = "blink.cmp", dir = "/nix/store/.../blink.cmp" },
    -- ... etc
}

-- Load on specific events
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.pack.add({ name = "rustaceanvim", dir = "/nix/store/.../rustaceanvim" })
    end,
    once = true,
})

-- Load on command
vim.api.nvim_create_user_command("Oil", function()
    vim.pack.add(lazy_plugins.oil)
    vim.cmd("Oil")
end, {})

-- Load on keymap
vim.keymap.set("n", "<leader>e", function()
    vim.pack.add(lazy_plugins.oil)
    require("oil").open()
end)

-- Load after startup (deferred)
vim.defer_fn(function()
    vim.pack.add(lazy_plugins.blink)
end, 100)  -- Load after 100ms
```

## More structured example:

```lua
-- lazy_loader.lua

local M = {}

M.plugins = {
    ["oil.nvim"] = {
        dir = "/nix/store/.../oil.nvim",
        keys = {
            { "<leader>e", function() require("oil").open() end },
        },
    },
    ["rustaceanvim"] = {
        dir = "/nix/store/.../rustaceanvim",
        ft = "rust",
    },
    ["blink.cmp"] = {
        dir = "/nix/store/.../blink.cmp",
        event = "InsertEnter",
    },
    ["treesitter"] = {
        dir = "/nix/store/.../nvim-treesitter",
        event = "VeryLazy",  -- Custom event you trigger
    },
}

local loaded = {}

function M.load(name)
    if loaded[name] then return end
    
    local plugin = M.plugins[name]
    if not plugin then
        vim.notify("Unknown plugin: " .. name, vim.log.levels.ERROR)
        return
    end
    
    vim.pack.add({ name = name, dir = plugin.dir })
    loaded[name] = true
end

function M.setup()
    for name, plugin in pairs(M.plugins) do
        -- Lazy load on filetype
        if plugin.ft then
            local filetypes = type(plugin.ft) == "table" and plugin.ft or { plugin.ft }
            vim.api.nvim_create_autocmd("FileType", {
                pattern = filetypes,
                callback = function()
                    M.load(name)
                end,
                once = true,
            })
        end
        
        -- Lazy load on event
        if plugin.event then
            local events = type(plugin.event) == "table" and plugin.event or { plugin.event }
            vim.api.nvim_create_autocmd(events, {
                callback = function()
                    M.load(name)
                end,
                once = true,
            })
        end
        
        -- Lazy load on keymap
        if plugin.keys then
            for _, key in ipairs(plugin.keys) do
                local lhs, rhs = key[1], key[2]
                vim.keymap.set("n", lhs, function()
                    M.load(name)
                    if type(rhs) == "function" then
                        rhs()
                    else
                        vim.cmd(rhs)
                    end
                end, { desc = "Load " .. name })
            end
        end
    end
end

return M
```

Then in your `init.lua`:

```lua
local lazy_loader = require("lazy_loader")
lazy_loader.setup()

-- Optionally load some plugins immediately
vim.pack.add({ name = "bamboo.nvim", dir = "/nix/store/.../bamboo.nvim" })
vim.cmd.colorscheme("bamboo")
```

## Key patterns:

1. **VeryLazy** - Use `vim.defer_fn()` to delay by ~100ms after startup
2. **FileType** - Load when opening specific file types
3. **InsertEnter** - Load when entering insert mode
4. **Commands** - Create placeholder commands that load the plugin first
5. **Keymaps** - Create keymaps that load the plugin before executing

This gives you 80% of what lazy.nvim does without the complexity. The main thing you lose is dependency resolution and automatic updates.