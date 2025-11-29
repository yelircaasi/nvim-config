vim.lsp.config["haskell-language-server"] = {
	cmd = { "haskell-language-server" },
	filetypes = { "haskell" },
	root_markers = { { "*.cabal" }, ".git" },
	settings = {},
}
