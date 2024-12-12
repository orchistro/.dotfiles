return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "dracula",
				globalstatus = false,
			},
			sections = {
				lualine_b = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_c = {},
			},
			inactive_sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
			},
		})
	end,
}
