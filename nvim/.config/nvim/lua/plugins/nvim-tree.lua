return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		MapCustomKey("<leader>nt", ":NvimTreeOpen<CR>", "[N]vim[T]ree")
		-- :hi NvimTreeCursorLine guibg=
		vim.cmd([[
      :hi NvimTreeCursorLine guibg=#d5d0be
      ]])
		require("nvim-tree").setup({
			view = {
				width = 40,
			},
			update_focused_file = {
				enable = true,
			},
		})
	end,
}
