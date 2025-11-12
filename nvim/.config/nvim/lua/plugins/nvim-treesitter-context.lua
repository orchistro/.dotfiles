return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local tscon = require("treesitter-context")
		tscon.setup({
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = false,
			multiline_threshold = 20,
			trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded.
			mode = "cursor", -- 커서 위치 기준
			separator = nil,
			zindex = 20, -- 다른 UI 요소와 겹칠 때 우선순위
		})

		vim.api.nvim_set_hl(0, "TreesitterContext", {
			bg = "#cfc9b6",
			bold = true,
		})

		vim.keymap.set("n", "<leader>tc", function()
			tscon.toggle()
		end, { desc = "Treesitter [C]ontext" })

		vim.keymap.set("n", "[c", function()
			tscon.go_to_context(vim.v.count1)
		end, { desc = "Go to [C]ontext", silent = true })

		tscon.disable() -- 시작시에는 디폴트로 꺼 둠. 필요할 때 <leader>tc로 켤 수 있도록
	end,
}
