vim.o.cursorline = false
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function(ctx)
		if ctx.match:match("/examples/") then
			vim.wo.cursorline = false
		else
			vim.wo.cursorline = true
		end
	end,
})
