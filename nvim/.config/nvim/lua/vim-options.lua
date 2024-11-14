vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("set number")
vim.cmd("set ic")

vim.cmd("set encoding=utf-8")
vim.cmd("set termencoding=utf-8")
vim.cmd("set fileencoding=utf-8")
vim.cmd("set fileencodings=utf-8")

vim.cmd("set makeprg=cd\\ build\\ &&\\ cmake\\ --build\\ .")

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<F4>", ":cp<CR>")
vim.keymap.set("n", "<F5>", ":cn<CR>")

vim.keymap.set("n", "<F10>", ":cexpr []<CR>:copen<CR><C-w>J:make<CR>")

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd("noremap <C-U> 3<C-U>")
vim.cmd("noremap <C-D> 3<C-D>")

vim.cmd("inoremap <C-E> <C-O><C-E>")
vim.cmd("inoremap <C-Y> <C-O><C-Y>")

vim.cmd("cnoremap <C-A> <Home>")
vim.cmd("nnoremap <F24> :%s/\\s\\+$//g<CR>")
vim.cmd("nnoremap <S-F12> :%s/\\s\\+$//g<CR>")

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


