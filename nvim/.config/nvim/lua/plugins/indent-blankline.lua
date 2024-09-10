return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {},
	config = function()
		local ibl = require("ibl")
		local c = "▏"
		ibl.setup({
			scope = { enabled = true },
			indent = { char = " " },
			-- indent = { char = "┊" },
		})

		vim.keymap.set("n", "<leader>if", function()
			ibl.setup({
				scope = { enabled = true },
				indent = { char = " " },
			})
		end, { silent = true, desc = "[I]ndent-blankline O[f]f" })

		vim.keymap.set("n", "<leader>in", function()
			ibl.setup({
				scope = { enabled = false },
				indent = { char = c },
			})
		end, { silent = true, desc = "[I]ndent-blankline O[n]" })

		-- 선이 아닌 바탕색으로 표시하는 방식
		-- local highlight = {
		--   "CursorColumn",
		--   "Whitespace",
		-- }
		-- require("ibl").setup {
		--   indent = { highlight = highlight, char = "" },
		--   whitespace = {
		--     highlight = highlight,
		--     remove_blankline_trail = false,
		--   },
		--   scope = { enabled = false },
		-- }
	end,
}
