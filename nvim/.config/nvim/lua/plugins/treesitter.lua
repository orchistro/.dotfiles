return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	config = function()
		local config = require("nvim-treesitter.configs")

		--- @diagnostic disable-next-line: missing-fields
		config.setup({
			ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				disable = { "dockerfile" },
			},
			indent = { enable = false },
		})
	end,
}
