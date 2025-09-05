return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("dapui").setup()

			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

				-- On windows you may have to uncomment this:
				-- detached = false,
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- dap.adapters.lldb = {
			-- 	type = "executable",
			-- 	-- command = "/usr/bin/lldb-dap-19",
			-- 	command = "lldb-dap-19",
			-- 	name = "lldb",
			-- }

			-- dap.configurations.cpp = {
			-- 	{
			-- 		name = "Launch",
			-- 		type = "lldb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 		stopOnEntry = false,
			-- 		args = {},
			-- 		-- 💀
			-- 		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
			-- 		--
			-- 		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
			-- 		--
			-- 		-- Otherwise you might get the following error:
			-- 		--
			-- 		--    Error on launch: Failed to attach to the target process
			-- 		--
			-- 		-- But you should be aware of the implications:
			-- 		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
			-- 		runInTerminal = false,
			-- 	},
			-- }
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]AP: Toggle [B]reakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]AP: [C]ontinue" })
			vim.keymap.set("n", "<leader>du", dap.up, { desc = "[D]AP: [U]p the callstack" })
			vim.keymap.set("n", "<leader>dd", dap.down, { desc = "[D]AP: [D]own the callstack" })
			vim.keymap.set("n", "<leader>d?", function()
				require("dapui").eval(nil, { enter = true })
			end, { desc = "[D]AP: Inspect[?] variable under cursor" })

			vim.keymap.set("n", "<leader>dt", dap.step_into, { desc = "[D]AP: s[T]ep into" })
			vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "[D]AP: [N]ext" })
			vim.keymap.set("n", "<leader>dr", dap.step_out, { desc = "[D]AP: [R]eturn" })
			-- vim.keymap.set("n", "<leader>", "<CMD>DapContinue<CR>")

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- vim.highlight.create("DapBreakpoint", { ctermbg = 0, guifg = "#993939", guibg = "#31353f" }, false)
			-- vim.highlight.create("DapLogPoint", { ctermbg = 0, guifg = "#61afef", guibg = "#31353f" }, false)
			-- vim.highlight.create("DapStopped", { ctermbg = 0, guifg = "#98c379", guibg = "#31353f" }, false)

			-- -  DapStopped = "󰁕",
			-- -  Debugger = "",

			vim.fn.sign_define(
				"DapBreakpoint",
				-- { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "󰁕", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)

			require("nvim-dap-virtual-text").setup({
				enabled = false, -- enable this plugin (the default)
				-- enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
				-- highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				-- highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				-- show_stop_reason = true, -- show stop reason when stopped for exceptions
				-- commented = false, -- prefix virtual text with comment string
				-- only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
				-- all_references = false, -- show virtual text on all all references of the variable (not only definitions)
				-- clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
				-- --- A callback that determines how a variable is displayed or whether it should be omitted
				-- --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
				-- --- @param buf number
				-- --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
				-- --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
				-- --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
				-- --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
				-- display_callback = function(variable, buf, stackframe, node, options)
				-- 	-- by default, strip out new line characters
				-- 	if options.virt_text_pos == "inline" then
				-- 		return " = " .. variable.value:gsub("%s+", " ")
				-- 	else
				-- 		return variable.name .. " = " .. variable.value:gsub("%s+", " ")
				-- 	end
				-- end,
				-- -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
				-- virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

				-- -- experimental features:
				-- all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
				-- virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
				-- virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
				-- -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
			})
		end,
	},
}
