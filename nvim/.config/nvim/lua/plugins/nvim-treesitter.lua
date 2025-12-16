return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.install({ "rust", "python", "cpp", "lua", "c", "bash", "zsh", "cmake", "asm", "json", "vim", "vimdoc" })
	end,
}
