-- vim: ft=teal expandtab sw=3 ts=3
local type vim = require("vim")

global record cfg
   record Config
      verbose: boolean
      safe: boolean
      prepend_safe: function(string): nil
      plugin_paths: {string:string}
      dependencies: {string:{string}}
      layers: {number}
      plugins_by_layer: {number:{string}}
   end

   record PluginConfig end
   
   record PluginWithSetup
      setup: function(PluginConfig)
   end
   
   type Plugin = table
   
   type SetupFunction = function(string, ? PluginConfig | function(Plugin)): nil

   type CustomSetupFunction = function(Plugin)
   
   -- type MapFunction = function(
   --    string|{string},
   --    string,
   --    string|function()
   -- )
   type MapFunction = function(
      string|{string},
      string,
      string|function(),
      ? vim.keymap.SetOpts
   )
   record Utils
      PLUGINS_INCLUDED: {string}
      printv: function(string): nil
      printb: function(string): nil
      printbv: function(string): nil
      call_safe: function(function, any, string): boolean, any
      print_status: function(integer, string, string, string)
      is_included: function(string): boolean
      get_plugin: function(string): Plugin
      packadd: function(string, ? function())
      setup_plugin: SetupFunction
      map: MapFunction
   end
end
