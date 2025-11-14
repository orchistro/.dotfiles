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
			auto_install = true, -- tree-sitter-cli 설치 필요: cargo install --locked tree-sitter-cli
			ignore_install = {},
			highlight = {
				enable = true,
				disable = { "dockerfile" },
			},
			indent = { enable = false },
		})
	end,
}
