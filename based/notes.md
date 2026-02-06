# Error handling in Lua

### 1. Basic "Try-Catch" with `pcall`

`pcall` (protected call) executes a function. If an error occurs, it catches it and returns `false` plus the error message. If it succeeds, it returns `true` plus any values returned by the function.

```lua
-- Standard pcall pattern
local success, result = pcall(function()
    -- This code is "protected"
    local data = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    error("Something went wrong!") -- Manual trigger for example
    return data
end)

if success then
    print("Success! Data length: " .. #result)
else
    -- 'result' contains the error message if success is false
    print("Caught an error: " .. result)
end

```

---

### 2. Advanced "Try-Catch" with `xpcall`

`xpcall` (extended protected call) is the same as `pcall`, but it allows you to pass a **message handler** function. This handler runs *before* the stack is unwound, which is essential if you want a full **stack trace** (using `debug.traceback`).

```lua
local function my_function()
    error("Oops!")
end

local function my_handler(err)
    return "Custom Error Handler: " .. debug.traceback(err)
end

local status, err_msg = xpcall(my_function, my_handler)

if not status then
    print(err_msg) -- Will print the error + the line-by-line stack trace
end

```

---

### 3. The "Neovim Way": Guard Clauses

While `pcall` is useful for "risky" operations (like network calls or parsing JSON), most Neovim power users prefer **Guard Clauses** (conditionals) for ergonomics. This prevents the "callback hell" of wrapping everything in functions.

**Avoid this:**

```lua
pcall(function()
    require('telescope').setup()
end)

```

**Do this instead:**

```lua
local status, telescope = pcall(require, "telescope")
if not status then
    return -- Silently exit if plugin isn't installed
end

telescope.setup({ ... })

```

---

### Summary Table

| Feature | Lua Equivalent | Notes |
| --- | --- | --- |
| **`try`** | `pcall(function() ... end)` | Wraps code in an anonymous function. |
| **`except` / `catch**` | `if not success then` | Checks the boolean return of `pcall`. |
| **`throw`** | `error("msg")` | Interrupts execution and bubbles up to the nearest `pcall`. |
| **`finally`** | *None* | You must manually handle cleanup after the `if/else` block. |

### When to use what?

* **Use `pcall**` when calling `require` or external commands that might fail.
* **Use `assert(condition, message)**` for simple validation where you *want* the script to stop if something is wrong.
* **Use `vim.validate**` (Neovim-specific) to check the types of function arguments cleanly.
