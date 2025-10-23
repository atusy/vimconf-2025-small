vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function(ctx)
		local function is_def(n)
			return vim.tbl_contains({
				"func_literal",
				"function_declaration",
				"function_definition",
				"method_declaration",
				"method_definition",
			}, n:type())
		end
		require("tsnode-marker").set_automark(ctx.buf, {
			target = function(_, node)
				if not is_def(node) then
					return false
				end
				local parent = node:parent()
				while parent do
					if is_def(parent) then
						return true
					end
					parent = parent:parent()
				end
				return false
			end,
			hl_group = "@illuminate",
		})
	end,
})
