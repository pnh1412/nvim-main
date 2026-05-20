local M = {}
local keymap = vim.keymap.set

local function supports_method(client, method, bufnr)
	local client_meta = getmetatable(client)
	if client_meta and client_meta.supports_method then
		return client_meta.supports_method(client, method, bufnr)
	end

	return client:supports_method(method, bufnr)
end

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
	keymap("n", "<leader>lA", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP | Native Code Action", silent = true })
	keymap("n", "Gl", "<cmd>Lspsaga show_line_diagnostics<cr>", { buffer = bufnr, silent = true })
	keymap("n", "Gp", "<cmd>Lspsaga peek_definition<cr>", { buffer = bufnr, silent = true })
	keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = bufnr, silent = true })
	keymap("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr, silent = true })
	keymap("n", "gr", "<cmd>Lspsaga finder<cr>", { buffer = bufnr, silent = true })
	keymap("n", "<leader>lc", vim.lsp.document_color.color_presentation, {
		buffer = bufnr,
		desc = "LSP | Color Presentation",
		silent = true,
	})
	keymap("v", "<leader>lA", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP | Native Code Action", silent = true })
end

M.lsp_highlight = function(client, bufnr)
	if supports_method(client, "textDocument/documentHighlight", bufnr) then
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

	if supports_method(client, "textDocument/inlayHint", bufnr) then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if vim.lsp.document_color and supports_method(client, "textDocument/documentColor", bufnr) then
		vim.lsp.document_color.enable(true, { bufnr = bufnr }, { style = "background" })
	end

	local semantic_tokens_disabled = {
		lua_ls = true,
	}

	if semantic_tokens_disabled[client.name] and supports_method(client, "textDocument/semanticTokens", bufnr) then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

return M
