local cwd = vim.uv.cwd()
vim.opt.runtimepath:prepend(vim.fs.joinpath(cwd, "runtime"))
require("vimconf")
