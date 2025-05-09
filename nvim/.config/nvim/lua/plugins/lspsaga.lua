return {
	"nvimdev/lspsaga.nvim",

	config = function()
		require("lspsaga").setup({
			symbol_in_winbar = {
				enable = false,
			},
			lightbulb = {
				enable = false, -- 여기서 lightbulb를 끕니다
			},
		})
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
		vim.keymap.set("n", "<C-W>d", "<cmd>Lspsaga show_line_diagnostics<CR>")
	end,

	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
}
