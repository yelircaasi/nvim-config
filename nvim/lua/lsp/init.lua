local diagnostic_modes = {
	{
		name = "End of Line (Virtual Text)",
		config = {
			virtual_text = {
				prefix = "●", -- Could be '■', '▎', 'x'
				spacing = 4,
				source = "if_many",
			},
			virtual_lines = false,
			signs = true,
			underline = true,
			update_in_insert = false,
		},
	},
	{
		name = "Under Line (Virtual Lines)",
		config = {
			virtual_text = false,
			-- 'virtual_lines' is now a built-in handler in Nvim 0.10/0.11+
			virtual_lines = {
				only_current_line = true, -- Only show for current line to reduce clutter
				highlight_whole_line = false,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
		},
	},
	{
		name = "Gutter Only (Signs)",
		config = {
			virtual_text = false,
			virtual_lines = false,
			signs = {
				-- Custom mapping for signs if you want specific characters
				text = {
					[vim.diagnostic.severity.ERROR] = "E",
					[vim.diagnostic.severity.WARN] = "W",
					[vim.diagnostic.severity.HINT] = "H",
					[vim.diagnostic.severity.INFO] = "I",
				},
			},
			underline = false, -- Often cleaner to disable underline in "minimal" mode
			update_in_insert = false,
		},
	},
}

-- State tracking
local current_mode_index = 1
local diagnostics_active = false

-- 2. Function to set the configuration
local function set_diagnostics_mode()
	if not diagnostics_active then
		vim.diagnostic.enable(false)
		-- print("LSP Diagnostics: OFF")
		return
	end

	vim.diagnostic.enable(true)
	local mode = diagnostic_modes[current_mode_index]
	vim.diagnostic.config(mode.config)
	print("LSP Mode: " .. mode.name)
end

-- 3. Keybind: Toggle On/Off
vim.keymap.set("n", "<leader>dt", function()
	diagnostics_active = not diagnostics_active
	set_diagnostics_mode()
end, { desc = "Toggle LSP Diagnostics" })

-- 4. Keybind: Cycle Modes
vim.keymap.set("n", "<leader>dm", function()
	-- Only cycle if active; otherwise turn on and reset to 1
	if not diagnostics_active then
		diagnostics_active = true
		current_mode_index = 1
	else
		current_mode_index = current_mode_index + 1
		if current_mode_index > #diagnostic_modes then
			current_mode_index = 1
		end
	end
	set_diagnostics_mode()
end, { desc = "Cycle LSP Diagnostic Modes" })

-- Initialize on startup
set_diagnostics_mode()
