require("github-theme")
vim.cmd("colorscheme github_light_high_contrast")
require("plugins.mini.statusline").setup()

vim.api.nvim_set_hl(0, "@string.python", { fg = "#A000A0" })
vim.api.nvim_set_hl(0, "@string.special.url.uri", { underline = true })
vim.api.nvim_set_hl(0, "@string.special.url.path.uri", { reverse = true })
vim.api.nvim_set_hl(0, "@string.special.url.path.python", { reverse = true })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#9090DD", fg = "#000000" })

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.number = true

local enable_tsnode_marker = true

if not enable_tsnode_marker then
	vim.api.nvim_set_hl(0, "@function.inner.python", { reverse = true })
else
	require("vimconf.tsnode-marker")
end

require("vimconf.cursorline")
