return {
	"kevinhwang91/nvim-hlslens",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"n",
			[[<cmd>execute('normal! ' . v:count1 . 'n')<cr>]] .. [[<cmd>lua require("hlslens").start()<cr>]],
		},
		{
			"N",
			[[<cmd>execute('normal! ' . v:count1 . 'N')<cr>]] .. [[<cmd>lua require("hlslens").start()<cr>]],
		},
		{ "*", "*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		{ "#", "#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		{ "g*", "g*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		{ "g#", "g#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
	},
	config = function()
		require("hlslens").setup({
			nearest_only = true,
			override_lens = function(render, posList, nearest, idx, relIdx)
				local text, chunks
				local lnum, col = unpack(posList[idx])

				if nearest then
					local cnt = #posList
          text = ("[%d/%d]"):format(idx, cnt)
					-- chunks = { { " " }, { text, "HlSearchLensNear" } }
          chunks = { { " " }, { text, "HlSearchLens" } }
				end

				render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
			end,
		})
	end,
}
