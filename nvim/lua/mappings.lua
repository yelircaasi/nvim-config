--[[
DESIRED MAPPINGS/ACTIONS

- open quickfix window
- open floating terminal
- copy selection to new file
- jump to reference (next, previous)
- jump to definition
- open search and replace (with preview)
- fold block
- fold/unfold all of given level
- toggle value under cursor
- rename everywhere (optionally with preview)
- search pattern/regex in given files -> save results list & use it to navigate
- show keybinds available
- add/view/edit comment/annotation pointing to given location
- view/navigate TODOs and comments
- insert snippet
- format code (optionally only under selection)
- edit selection in new buffer
- dull colors outside of selection
- edit filesystem as a buffer (oil.nvim?)
- get autocomplete suggestion
- check spelling in file (ONLY on command!)
- view diff (with saved, last commit, etc.)
- file tree view
- navigate between search results
- toggle to light colors (or even lighten/darken colors, increase contrast -> write plugin?)
- jump to next syntactic object ( 
- command to run changed tests (use testmon or analogous)
- get LLM feedback
- unified preview_+accept/reject framework
- multi-line / multi-location edits

AUTOMATIC/TOGGLABLE FUNCTIONALITIES
--> dull colors everywhere except in active block (via treesitter?)
--> custom syntax highlighting for my special formats (from consilium-notes: jn, ...)

--]]

-- Set up a local map function for convenience
local map = vim.keymap.set

-- telescope ----------------------------------------------------------------------------------------------------------
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find Files" })
map("n", "<leader>gf", function() require("telescope.builtin").git_files() end, { desc = "Find Git Files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live Grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find Buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Find Help Tags" })

-- floaterm -----------------------------------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>ft", "<Cmd>FloatermToggle<CR>", { desc = "Toggle floaterm" })
vim.keymap.set("t", "<leader>ft", "<C-\\><C-n><Cmd>FloatermToggle<CR>", { desc = "Toggle floaterm" })

-- LSP ----------------------------------------------------------------------------------------------------------------
-- We will create an autocommand group to attach keymaps only to buffers with an active LSP client.
local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_keymaps_group,
    callback = function(ev)
        local lsp_map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
        end

        -- Navigation and Information
        lsp_map("gd", vim.lsp.buf.definition, "Go to Definition")
        lsp_map("gD", vim.lsp.buf.declaration, "Go to Declaration")
        lsp_map("gr", vim.lsp.buf.references, "Go to References")
        lsp_map("gI", vim.lsp.buf.implementation, "Go to Implementation")
        lsp_map("K", vim.lsp.buf.hover, "Hover Documentation")
        lsp_map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- Actions
        lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")

        -- Diagnostics
        lsp_map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        lsp_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        lsp_map("<leader>dl", vim.diagnostic.open_float, "Show Line Diagnostics")

        -- format on save (to use LSP formatter instead of conform)
        -- vim.api.nvim_buf_create_autocmd("BufWritePre", {
        --   buffer = ev.buf,
        --   callback = function() vim.lsp.buf.format { async = false } end
        -- })
    end,
})