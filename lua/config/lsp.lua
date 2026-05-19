local M = {}
local keymap = vim.keymap.set

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.lsp_keymaps = function(bufnr)
	keymap("n", "GD", "<cmd>Lspsaga finder<cr>", { buffer = bufnr, silent = true })
	keymap("n", "Gd", "<cmd>Lspsaga goto_definition<cr>", { buffer = bufnr, silent = true })
	keymap("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP | Code Action", silent = true })
	keymap("n", "Gl", "<cmd>Lspsaga show_line_diagnostics<cr>", { buffer = bufnr, silent = true })
	keymap("n", "Gp", "<cmd>Lspsaga peek_definition<cr>", { buffer = bufnr, silent = true })
	keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = bufnr, silent = true })
	keymap("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr, silent = true })
	keymap("n", "gr", "<cmd>Lspsaga finder<cr>", { buffer = bufnr, silent = true })
	keymap("v", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP | Code Action", silent = true })
end

M.lsp_highlight = function(client, bufnr)
	if client:supports_method("textDocument/documentHighlight") then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

M.on_attach = function(client, bufnr)
	M.lsp_keymaps(bufnr)
	M.lsp_highlight(client, bufnr)

	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	local semantic_tokens_disabled = {
		lua_ls = true,
	}

	if semantic_tokens_disabled[client.name] and client:supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

return M
