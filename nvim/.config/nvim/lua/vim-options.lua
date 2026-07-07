vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("set ic")

vim.cmd("set encoding=utf-8")
vim.cmd("set fileencoding=utf-8")
vim.cmd("set fileencodings=utf-8")

vim.cmd("set makeprg=cmake\\ --build\\ build")

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = false

-- 우클릭 popup 메뉴와 native pum (cmdline wildmenu 등) 에 rounded 테두리 (nvim 0.12+)
-- insert 모드 자동완성은 nvim-cmp 가 자체 rounded float 로 그리므로 이 옵션과 무관
-- 테두리 색은 hl-PmenuBorder 로 조정 가능
if vim.fn.has("nvim-0.12") == 1 then
	vim.opt.pumborder = "rounded"
end

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
