local document_highlight = {}

vim.api.nvim_create_augroup('lsp_document_highlight', {
	clear = false
})

function document_highlight.start(bufnr)
	vim.api.nvim_clear_autocmds({
		buffer = bufnr,
		group = 'lsp_document_highlight',
	})
	vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
		group = 'lsp_document_highlight',
		buffer = bufnr,
		callback = vim.lsp.buf.document_highlight,
	})
	vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
		group = 'lsp_document_highlight',
		buffer = bufnr,
		callback = vim.lsp.buf.clear_references,
	})
end

function document_highlight.stop(bufnr)
	vim.api.nvim_clear_autocmds({
		buffer = bufnr,
		group = 'lsp_document_highlight',
	})
	vim.lsp.buf.clear_references()
end

return document_highlight
