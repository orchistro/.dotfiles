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
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_a = {
					{ "filename", path = 1 },
				},
				lualine_b = {
					{ "branch", padding = { left = 1, right = 1 } },
				},
				lualine_c = {},
				lualine_x = {
					{
						"lsp_status",
						icon = "", -- f013
						symbols = {
							-- Standard unicode symbols to cycle through for LSP progress:
							spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
							-- Standard unicode symbol for when LSP is done:
							done = "✓",
							-- Delimiter inserted between LSP names:
							separator = "",
						},
						-- List of LSP names to ignore (e.g., `null-ls`):
						ignore_lsp = {},
						-- Display the LSP name
						show_name = false,
					},
				},
				lualine_y = {
					{ "encoding", padding = { left = 0, right = 0 } },
					{ "fileformat", padding = { left = 0, right = 1 } },
				},
				lualine_z = { { "location", padding = { left = 1, right = 0 } } },
			},
			inactive_sections = {
				lualine_c = {
					{ "filename", path = 1 },
					{ "branch", padding = { left = 1, right = 1 } },
				},
			},
		})
	end,
}
