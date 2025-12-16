return {
	"MeanderingProgrammer/treesitter-modules.nvim",
	config = function()
		require("treesitter-modules").setup({
			-- list of parser names, or 'all', that must be installed
			ensure_installed = {},
			-- list of parser names, or 'all', to ignore installing
			ignore_install = {},
			-- install parsers in ensure_installed synchronously
			sync_install = false,
			-- automatically install missing parsers when entering buffer
			auto_install = false,
			fold = {
				enable = false,
				disable = false,
			},
			highlight = {
				enable = true, -- need this for rainbow-delimiters to work
				disable = false,
				-- setting this to true will run `:h syntax` and tree-sitter at the same time
				-- set this to `true` if you depend on 'syntax' being enabled
				-- using this option may slow down your editor, and duplicate highlights
				-- instead of `true` it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = false,
				disable = false,
				-- set value to `false` to disable individual mapping
				-- node_decremental captures both node_incremental and scope_incremental
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			indent = {
				enable = false,
				disable = false,
			},
		})
	end,
}
