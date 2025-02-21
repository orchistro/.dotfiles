return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	opts = {
		color_overrides = {
			latte = {
				base = "#fbf6e4",
				mantle = "#f1ebd8",
				crust = "#000000",
			},
		},
		custom_highlights = function(colors)
			return {
				Search = { bg = "#FFFF7E" },
				CurSearch = { fg = colors.text, bg = "#FFB863" },
				IncSearch = { fg = colors.text, bg = "#FFB863" },

				-- hlslens에 의한 search count(옆에 뜨는 [17/56]) 색상
				HlSearchLens = { fg = colors.flamingo, bg = "#FFFFFF" },

        -- 커서 아래의 단어 강조 색상
        LspReferenceText = { bg = "#FBE0F7" },
        LspReferenceRead = { bg = "#FBE0F7" },
        LspReferenceWrite = { bg = "#FBE0F7" },
			}
		end,
	},
}
