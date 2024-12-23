return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        vim.keymap.set('n', ']g', function()
          if vim.wo.diff then
            vim.cmd.normal({']g', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end,
        { desc = "Next [g]it change" })

        vim.keymap.set('n', '[g', function()
          if vim.wo.diff then
            vim.cmd.normal({'[g', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end,
        { desc = "Previous [g]it change" })
      end
    },
  },
}
