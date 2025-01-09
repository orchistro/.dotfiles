return {
  "christoomey/vim-tmux-navigator",
  vim.keymap.set("n", "<a-j>", ":TmuxNavigateDown<CR>"),
  vim.keymap.set("n", "<a-k>", ":TmuxNavigateUp<CR>"),
  vim.keymap.set("n", "<a-h>", ":TmuxNavigateLeft<CR>"),
  vim.keymap.set("n", "<a-l>", ":TmuxNavigateRight<CR>")
}
