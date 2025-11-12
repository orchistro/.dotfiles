return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			-- color_overrides = {
			-- 	latte = {
			-- 		rosewater = "#fdf7e8",
			-- 		flamingo = "#cb4b16",
			-- 		pink = "#d33682",
			-- 		mauve = "#6c71c4",  -- keywords (closs, if, public, return, ...)
			-- 		red = "#dc322f",
			-- 		maroon = "#d14371", -- arguments
			-- 		peach = "#cb4b1f",
			-- 		yellow = "#b58900", -- #directives, namespaces
			-- 		green = "#859900", -- header file name, string constants
			-- 		teal = "#2aa198", -- operators (*, &, =, ...)
			-- 		sky = "#2398d2",
			-- 		sapphire = "#0077b3",
			-- 		blue = "#268bd2", -- function name
			-- 		lavender = "#7b88d3",
			-- 		text = "#657b83",
			-- 		subtext1 = "#586e75",
			-- 		subtext0 = "#073642",
			-- 		overlay2 = "#bbbbbb", -- comments
			-- 		overlay1 = "#839496",
			-- 		overlay0 = "#93a1a1",
			-- 		surface2 = "#eee8d5",
			-- 		surface1 = "#c9cacd", -- line no
			-- 		surface0 = "#ccd0da", -- indent line
			-- 		base = "#fdf6e3", -- main bg color
			-- 		mantle = "#efe9d4", -- popup bgcolor, cursor location
			-- 		crust = "#96836e", -- window separator
			-- 	},
			-- },
			color_overrides = {
				latte = {
					blue = "#5784da", -- neotree directory color
					base = "#fbf6e4", -- main bg color
					mantle = "#efe9d4", -- popup bg color, cursor location
					crust = "#96836e", -- window separator
				},
			},
			highlight_overrides = {
				latte = function(C)
					return {
						FlashLabel = { fg = C.base, bg = C.red, style = { "bold" } },
					}
				end,
			},
			custom_highlights = function(colors)
				return {
					Search = { bg = "#FFF095" },
					CurSearch = { fg = colors.text, bg = "#FFC543" },
					IncSearch = { fg = colors.text, bg = "#FFC543" },

					-- hlslens에 의한 search count(옆에 뜨는 [17/56]) 색상
					HlSearchLens = { fg = colors.lavender, bg = "#FFFFFF" },

					-- 커서 아래의 단어 강조 색상
					LspReferenceText = { bg = "#FBE0F7" },
					LspReferenceRead = { bg = "#FBE0F7" },
					LspReferenceWrite = { bg = "#FBE0F7" },

					-- Neotree 선택 파일 색상
					NeoTreeCursorLine = { bg = "#accea5" },
				}
			end,
		},
	},
}
