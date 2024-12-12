return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"hrsh7th/cmp-cmdline",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls = require("luasnip")

			-- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
			-- snippet을 띄운 후 placeholder에서 타이핑을 하다가 다음 placeholder로 넘어가거나
			-- 이전 placeholder로 넘어가는 키 맵
			vim.keymap.set({ "i", "s" }, "<C-K>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-J>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),

					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "copilot" },
				}, {
					{
						name = "buffer",
						option = {
							keyword_pattern = [[\k\+]],
						},
					},
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{
						name = "buffer",
						option = {
							keyword_pattern = [[\k\+]],
						},
					},
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})

			-- 이 부분은 lsp-config.lua 에서 default_capabilities를 호출해서 설정하고 있다.
			-- 여기서 setup을 하게 되면, clangd setup을 여기서 해 버리기 때문에
			-- filetype등의 옵션이 설정된 lsp-config.lua에서 하고 있는 설정들이 올바로 clangd로 전달되지 않는다.
			-- 그래서 지우려고 했으나 기록을 남겨 두기 위해 주석 처리함
			--
			-- Set up lspconfig.
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
			-- require("lspconfig")["clangd"].setup({
			-- 	capabilities = capabilities,
			-- })
		end,
	},
}
