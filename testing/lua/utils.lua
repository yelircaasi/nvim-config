

local setup = function(config)
    local debug = config.debug
    local prepend_safe = config.prepend_safe
    local plugin_paths = config.plugin_paths
    local dependencies = config.dependencies
    local layers = config.layers
    local plugins_by_layer = config.plugins_by_layer

    local M = {}

    M.PLUGINS_INCLUDED = {}
    for _, layer in ipairs(layers) do
                local layer_table = plugins_by_layer[layer]
                print("--- layer " .. layer .. ": " .. #layer_table .. " plugins")
            
                for __, name in ipairs(layer_table) do
                    table.insert(M.PLUGINS_INCLUDED, name)
                end
            end

    M.printv = function(msg)
        if DEBUG then
            print(msg)
        end
    end

    M.printb = function(msg)
        local bar = string.rep("=", 120)
        local end_bar = string.rep("=", 115 - string.len(msg))
        print(bar)
        print("=== " .. msg .. " " .. end_bar)
        print(bar)
    end

    M.call_safe = function(func, arg, err_msg)
        local result, return_value = pcall(func, arg)
        if not result then
            M.printb(err_msg)
            return false, nil
        else
            return true, return_value
        end
    end

    M.print_status = function(length, prefix, name, suffix)
        local pad = string.rep(" ", length - string.len(name))
        print(prefix .. " " .. name .. pad .. " " .. suffix)
    end

    M.is_included = function(plugin_name)
        return vim.tbl_contains(M.PLUGINS_INCLUDED, plugin_name)
    end

    M.get_plugin = function(plugin_name)
            if not M.is_included(plugin_name) then return end
            local path = plugin_paths[plugin_name]
            -- print(path)
            local deps = dependencies[plugin_name]
            prepend_safe(path)
            if deps then
                for _, dep_name in ipairs(deps) do
                    local dep_path = plugin_paths[dep_name]
                    -- print(dep_path)
                    prepend_safe(dep_path)
                end
            end
            local required = require(plugin_name)
            return required
        end

    M.packadd = function(plugin_name, custom_func)
            if not M.is_included(plugin_name) then return end
            local path = plugin_paths[plugin_name]
            prepend_safe(path)
            vim.cmd("packadd " .. plugin_name)
            if custom_func then custom_func() end
    end

    
    local function setup_plugin_safe(plugin_name, config_or_function)
            if not M.is_included(plugin_name) then return end
            local result, plugin = pcall(M.get_plugin, plugin_name)
            if not result then
                print("ERROR: plugin require unsuccessful: " .. plugin_name)
                return
            end
            if not config_or_function then return end
            if type(config_or_function) == "table" then
                local config = config_or_function
                M.call_safe(plugin.setup, config, "ERROR: configuring" .. plugin_name)
                return
            end	
            if type(config_or_function) == "function" then
                local custom_setup_function = config_or_function
                M.call_safe(custom_setup_function, plugin, "ERROR: custom setup function failed for " .. plugin_name)
                return
            end
            print("ERROR: 'config_or_function' must be nil, table, or function; found " .. type(config_or_function)) 
        end
    local function setup_plugin_default(plugin_name, config_or_function)
            if not M.is_included(plugin_name) then return end
            local plugin = M.get_plugin(plugin_name)
            if not config_or_function then return end
            if type(config_or_function) == "table" then
                local config = config_or_function
                plugin.setup(config)
                return
            end	
            if type(config_or_function) == "function" then
                local custom_setup_function = config_or_function
                custom_setup_function(plugin)
                return
            end
            error("'config_or_function' must be nil, table, or function; found " .. type(config_or_function)) 
        end

    M.setup_plugin = (debug and setup_plugin_safe) or setup_plugin_default
    return M
end


return {setup = setup}
