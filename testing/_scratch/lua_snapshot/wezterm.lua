
if WEZTERM then
	-- https://github.com/ianhomer/wezterm.nvim/blob/main/lua/wezterm.lua --------------------------------------------------
	local wez = {}

	local directions = {
		h = "Left",
		l = "Right",
		j = "Down",
		k = "Up",
	}

	local arrows = {
		h = "left",
		l = "right",
		j = "down",
		k = "up",
	}

	local function command(args)
		os.execute("wezterm cli " .. args)
	end

	function wez.navigate(direction)
		command("activate-pane-direction " .. directions[direction])
	end

	function wez.go_direction(direction)
		local current_window = vim.fn.win_getid()
		vim.api.nvim_command("wincmd " .. direction)
		local at_edge = current_window == vim.fn.win_getid()
		if at_edge then
			wez.navigate(direction)
		end
	end

	function wez.keys()
		local keys = {}
		for key, _ in pairs(directions) do
			table.insert(keys, {
				"<c-" .. key .. ">",
				function()
					wez.go_direction(key)
				end,
				mode = { "n" },
				desc = "Navigate " .. arrows[key],
			})
		end

		return keys
	end

	function wez.setup(opts)
		for key, _ in pairs(directions) do
			vim.keymap.set("", "<c-" .. key .. ">", function()
				wez.go_direction(key)
			end)
			-- support ctrl arrow keys in normal an insert mode
			vim.keymap.set({ "i", "n", "v", "x", "c" }, "<c-" .. arrows[key] .. ">", function()
				print("D" .. key)
				M.go_direction(key)
			end)
		end
	end

	-- return wez
	--
	-- https://github.com/letieu/wezterm-move.nvim/blob/master/lua/wezterm-move/init.lua ----------------------------------
	local WM = {}

	local wezterm_directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

	-- @param direction: string (h, j, k, l)
	local function at_edge(direction)
		return vim.fn.winnr() == vim.fn.winnr(direction)
	end

	local function wezterm_exec(cmd)
		local command = vim.deepcopy(cmd)
		if vim.fn.executable("wezterm.exe") == 1 then
			table.insert(command, 1, "wezterm.exe")
		else
			table.insert(command, 1, "wezterm")
		end
		table.insert(command, 2, "cli")
		return vim.fn.system(command)
	end

	-- @param direction: string (h, j, k, l)
	local function send_key_to_wezterm(direction)
		wezterm_exec({ "activate-pane-direction", wezterm_directions[direction] })
	end

	-- @param direction: string (h, j, k, l)
	WM.move = function(direction)
		if at_edge(direction) then
			send_key_to_wezterm(direction)
		else
			vim.cmd("wincmd " .. direction)
		end
	end
end

