"""
# Symlinking

Using Python to manage your Neovim plugins via symlinking is a great "middle-ground" strategy. It allows you to keep your plugins in a custom folder (like `~/repos/plugins`) while making Neovim think they are installed in the standard `site/pack` directory.

When Neovim sees a plugin in `site/pack/*/start/`, it adds it to the `runtimepath` **automatically** at startup, which is faster than manual Lua loops.

### The Python Symlink Script

This script will take everything in your `SOURCE_DIR` and create a symlink for it in the Neovim "start" package directory.


### Why this is better for your "Mac to Nix" transition

* **Zero Startup Cost:** Unlike the Lua loop, Neovim's C-code handles these symlinks. It scans the `pack/*/start` folder once and adds them to the `runtimepath` before `init.lua` even runs. This will help reduce that **50ms** `init.lua` parsing time you're seeing.
* **Documentation Support:** Manual `runtimepath` manipulation often breaks `:help`. By putting plugins in the `pack` folder (even via symlink), Neovim automatically indexes the `/doc` folders so tags like `:help yazi` will actually work.
* **Nix Compatibility:** This mirrors how Nix manages plugins. Nix effectively creates a "store" of plugins and symlinks them into a profile. By doing this in Python now, you're training your config to expect a standard `pack` layout.

### How to use it

1. Run the script once from your terminal.
2. In your `init.lua`, you can **remove** all the manual `prepend` and `runtimepath` logic.
3. Just keep the `require("yazi").setup()` call.

### Pro-Tip for 2026

Since you're on a Mac, you might run into "Security & Privacy" prompts if you try to execute binaries inside symlinked folders. Running the Python script via `sudo` is usually **not** necessary and can mess up permissions. Stick to running it as your local user (`ext_riley`).

**Would you like me to add a "Cleanup" feature to the script that deletes symlinks in the target folder if the source plugin has been deleted?**

> What about to link them into the lazy-loaded (manually-loaded) folder?

Linking your plugins into the **manually-loaded** folder (historically called the `opt` directory) is a "state-of-the-art" strategy for keeping your startup time lean.

In Neovim's package architecture, plugins in the `start/` folder load automatically, while plugins in the `opt/` folder do **nothing** until you explicitly call `:packadd` or `require` them.

### 1. The Python Symlink Script (for `opt`)

This version of the script changes the target to the `opt` directory. It also includes a **cleanup feature** to ensure that if you delete a plugin from your source folder, the broken symlink is removed from Neovim.

### 2. How to load them in `init.lua`

Because these are now in `opt`, Neovim won't see them at all until you "activate" them. This is the secret to getting your `init.lua` parsing time down from 50ms.

Instead of just `require("yazi")`, you now do this:

```lua
-- This one line handles the runtimepath, the doc tags, and the plugin files
vim.cmd("packadd yazi")

-- Now that it's on the path, you can configure it
require("yazi").setup({
  -- your config here
})

### 3. Why `opt` is better for your 50ms problem

When a plugin is in `start`, Neovim spends time during the **C-level startup** scanning every subdirectory (colors, ftplugin, indent, etc.). If you have 20 plugins in `start`, that’s a lot of disk IO before you even see the UI.

By moving them to `opt`:

* **The "Zero-Cost" Init:** Your `init.lua` only loads exactly what you need.
* **Conditional Loading:** You can wrap the `packadd` in an `autocmd` so that `yazi` only loads when you actually try to use a file explorer, or `python` parsers only load when you open a `.py` file.

### 4. Comparison: `start` vs `opt`

| Feature | `start/` | `opt/` |
| --- | --- | --- |
| **Load Time** | At boot (Automatic) | On demand (`packadd`) |
| **Startup Impact** | High (Multiplied by # of plugins) | Zero (Until called) |
| **Management** | Simple (Drop and forget) | Controlled (Requires `packadd`) |
| **Best For** | Core UI, Themes, Essential tools | Language servers, Heavy plugins, `yazi` |

---

### Pro-Tip for 2026: The "Silent" Packadd

In Neovim 0.12, if you call `packadd` and the folder doesn't exist, it might throw a Vim error. Use a safe wrapper to keep your startup pretty:

```lua
local function safe_load(plugin)
    local ok = pcall(vim.cmd, "packadd " .. plugin)
    if not ok then
        print("Warning: Plugin " .. plugin .. " not found in opt/")
    end
end

safe_load("yazi")

```

**Would you like me to help you write an `autocmd` that automatically calls `packadd` only when you enter a specific file type?**

> Sure! Also explain how performance would be affected by a plugins.lua file passing a table of plugin names and their paths, to be used in init.lua for loading plugins and adding then to the RTP when they are needed?

Moving your plugin loading logic into a `plugins.lua` file and passing a table to `init.lua` is a standard "modular" approach. However, there are specific performance nuances in how you handle that table.

### 1. The Performance Impact: Lua Overhead

The performance cost comes from two places: **File IO** and **Table Iteration**.

* **File IO (Minor):** Calling `require("plugins")` is extremely fast on your Mac’s SSD (usually < 1ms). Neovim caches the result, so subsequent calls are essentially free.
* **RTP Manipulation (Variable):** If you iterate through a table of 50 plugins and call `vim.opt.runtimepath:prepend()` for each one inside `init.lua`, you are triggering a "re-indexing" of Neovim's internal search paths 50 times. This is where your **50ms** startup time starts to creep up.

### 2. The "State-of-the-Art" Lazy Implementation

To keep performance high, your `plugins.lua` shouldn't just be a list; it should be a map. You use this map to perform **Conditional Loading** (also known as "Lazy Loading").

**plugins.lua**

```lua
return {
  yazi = {
    path = "~/.local/share/nvim/site/pack/manual/opt/yazi",
    ft = { "dirvish", "netrw" }, -- Load only for these filetypes
  },
  ["nvim-treesitter"] = {
    path = "~/.local/share/nvim/site/pack/manual/opt/nvim-treesitter",
    ft = { "python", "lua", "javascript" },
  }
}

```

**init.lua**

```lua
local plugins = require("plugins")

-- Create a generic autocommand to load plugins by filetype
for name, config in pairs(plugins) do
  if config.ft then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = config.ft,
      callback = function()
        -- Use packadd for the 'opt' symlinks we created with Python
        vim.cmd("packadd " .. name)
        -- Trigger configuration if needed
        local ok, mod = pcall(require, name)
        if ok and mod.setup then mod.setup() end
      end,
    })
  end
end

```

### 3. Why this solves the performance issue

1. **Deffered Cost:** Instead of spending 50ms at startup loading everything, you spend **0ms**. The "cost" is paid only when you open a `.py` file or a directory.
2. **RTP Stability:** Neovim doesn't have to manage a massive `runtimepath` for a simple `git commit` or text edit.
3. **Clean init.lua:** Your `init.lua` remains tiny. It just sets up the "triggers" (autocmds) rather than doing the heavy lifting.

---

### 4. Comparison: Native `packadd` vs. Manual `RTP`

Using `packadd` (with your Python symlinks in `opt/`) is significantly more performant than manual `runtimepath:append()`.

| Method | Mechanics | Performance |
| --- | --- | --- |
| **Manual Table + `prepend**` | Lua manually updates a string list. | **Slower.** Triggers RTP refreshes in Lua space. |
| **`packadd` (Native)** | C-code handles the path injection and sources `/plugin` files. | **Fast.** Optimized by the Neovim core. |
| **`require` alone** | Lua searches existing paths. | **Neutral.** Only works if the plugin is already in the RTP. |

### Summary for your 50ms Goal

By using the **Python symlinking script** to put plugins in `opt/` and the **Autocmd logic** above to `packadd` them, you can likely get your `init.lua` parsing time down from **50ms to under 10ms**.

**Would you like me to help you refine the `FileType` autocommand to also handle "Keybind Loading" (e.g., only load a plugin when you hit a specific key)?**

"""

import os
from pathlib import Path

# 1. Define your paths
# Where you keep your cloned repos
SOURCE_DIR = Path("~/.local/share/nvim-plugins").expanduser()
# Where Neovim looks for "start" plugins (Standard for 0.12)
TARGET_DIR = Path("~/.local/share/nvim/site/pack/manual/start").expanduser()


def sync_plugins():
    # Ensure the target directory exists
    TARGET_DIR.mkdir(parents=True, exist_ok=True)

    print(f"--- Syncing plugins to {TARGET_DIR} ---")

    # 2. Iterate through your source plugins
    for item in SOURCE_DIR.iterdir():
        if item.is_dir():
            link_path = TARGET_DIR / item.name

            # 3. Handle existing links/files
            if link_path.exists() or link_path.is_symlink():
                if link_path.is_symlink() and os.readlink(link_path) == str(item):
                    print(f"OK: {item.name} is already linked.")
                    continue
                else:
                    print(f"REMOVING: Old/Invalid path at {link_path}")
                    if link_path.is_dir() and not link_path.is_symlink():
                        import shutil

                        shutil.rmtree(link_path)
                    else:
                        link_path.unlink()

            # 4. Create the symlink
            try:
                os.symlink(item, link_path)
                print(f"CREATED: {item.name} -> {item}")
            except OSError as e:
                print(f"FAILED: Could not link {item.name}: {e}")


if __name__ == "__main__":
    sync_plugins()


import shutil
from pathlib import Path

# Where your clones live
SOURCE_DIR = Path("~/.local/share/nvim-plugins").expanduser()
# The 'opt' folder for manual/lazy loading
TARGET_DIR = Path("~/.local/share/nvim/site/pack/manual/opt").expanduser()


def sync_opt_plugins():
    TARGET_DIR.mkdir(parents=True, exist_ok=True)

    source_plugins = {item.name: item for item in SOURCE_DIR.iterdir() if item.is_dir()}

    # 1. Create/Update Symlinks
    for name, path in source_plugins.items():
        link_path = TARGET_DIR / name
        if link_path.is_symlink():
            if os.readlink(link_path) == str(path):
                continue
            link_path.unlink()
        elif link_path.exists():
            shutil.rmtree(link_path)

        os.symlink(path, link_path)
        print(f"LINKED: {name}")

    # 2. Cleanup (Delete symlinks that no longer have a source)
    for link in TARGET_DIR.iterdir():
        if link.name not in source_plugins:
            print(f"CLEANING UP: {link.name}")
            if link.is_symlink():
                link.unlink()
            else:
                shutil.rmtree(link)


if __name__ == "__main__":
    sync_opt_plugins()
