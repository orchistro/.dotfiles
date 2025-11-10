return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "ayu_light",
				globalstatus = false,
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_a = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_b = { "branch", "diff" },
				lualine_c = {},
				lualine_x = { "encoding", "fileformat" },
				lualine_y = {},
				lualine_z = { "location" },
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
