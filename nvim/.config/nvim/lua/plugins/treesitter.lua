return {
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				highlight = {
					enable = true,
					disable = { "dockerfile" },
				},
				indent = { enable = false },
				-- Enable Rainbow Parentheses
				rainbow = { enable = true },
			})
		end,
	},
}
