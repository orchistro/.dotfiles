return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    MapCustomKey("<leader>nt", ':Neotree filesystem reveal left<CR><C-W>=', "[N]eo-[T]ree")
    vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = '#d5d0be' })
  end
}
