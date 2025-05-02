-- seamless tmux-nvim navigation
vim.keymap.set("n", "<a-j>", ":TmuxNavigateDown<CR>")
vim.keymap.set("n", "<a-k>", ":TmuxNavigateUp<CR>")
vim.keymap.set("n", "<a-l>", ":TmuxNavigateRight<CR>")
vim.keymap.set("n", "<a-h>", ":TmuxNavigateLeft<CR>")

-- nvimtree
vim.keymap.set("n", "<F2>", ":cp<CR>")
vim.keymap.set("n", "<F3>", ":cn<CR>")

-- quickfix
vim.keymap.set("n", "<F4>", ":cp<CR>")
vim.keymap.set("n", "<F5>", ":cn<CR>")

-- Make
-- vim.keymap.set("n", "<F10>", ":cexpr []<CR>:copen<CR><C-w>J:make<CR>")
vim.keymap.set("n", "<F10>", ":make<CR>")

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Scroll the screen without moving the cursor
vim.keymap.set("n", "<C-U>", "3<C-U>")
vim.keymap.set("n", "<C-D>", "3<C-D>")

-- Scroll the screen up/down with cursor
vim.keymap.set("i", "<C-E>", "<C-O><C-E>")
vim.keymap.set("i", "<C-Y>", "<C-O><C-Y>")

-- Remove trailing whitespace
vim.keymap.set("n", "<F24>", ":%s/\\s\\+$//g<CR>")
vim.keymap.set("n", "<S-F12>", ":%s/\\s\\+$//g<CR>")

-- Move to the beginning of the line in command mode
vim.keymap.set("c", "<C-A>", "<Home>")

vim.keymap.set(
	"n",
	"<C-w><C-]>",
	":vertical stag <C-R><C-W><CR>",
	{ desc = "Open vertical split window and jump to the tag definition" }
)

vim.keymap.set(
	"n",
	"<C-w>]",
	":stag <C-R><C-W><CR>",
	{ desc = "Open split window and jump to the tag definition" }
)
