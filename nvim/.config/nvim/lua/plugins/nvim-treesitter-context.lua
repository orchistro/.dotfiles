return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = false,
      multiline_threshold = 20,
      trim_scope = 'inner',  -- Which context lines to discard if `max_lines` is exceeded.
      mode = 'cursor',       -- 커서 위치 기준
      separator = nil,
      zindex = 20,           -- 다른 UI 요소와 겹칠 때 우선순위
    })
  end
}

