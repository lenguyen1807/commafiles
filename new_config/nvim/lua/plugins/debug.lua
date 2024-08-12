return {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
	-- Creates a beautiful debugger UI
	'rcarriga/nvim-dap-ui',

	-- Required dependency for nvim-dap-ui
	'nvim-neotest/nvim-nio',

	-- Installs the debug adapters for you
	'williamboman/mason.nvim',
	'jay-babu/mason-nvim-dap.nvim',
    },
    keys = function(_, keys)
	local dap = require 'dap'
	local dapui = require 'dapui'
	return {
	-- Basic debugging keymaps, feel free to change to your liking!
	{ '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
	{ '<F1>', dap.step_into, desc = 'Debug: Step Into' },
	{ '<F2>', dap.step_over, desc = 'Debug: Step Over' },
	{ '<F3>', dap.step_out, desc = 'Debug: Step Out' },
	{ '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
	{
	    '<leader>B',
	    function()
	    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
	    end,
	    desc = 'Debug: Set Breakpoint',
	},
	-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
	{ '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
	unpack(keys),
	}
    end,
    config = function()
	local dap = require 'dap'
	local dapui = require 'dapui'

	require('mason-nvim-dap').setup {
	    -- Makes a best effort to setup the various debuggers with
	    -- reasonable debug configurations
	    automatic_installation = true,

	    -- You can provide additional configuration to the handlers,
	    -- see mason-nvim-dap README for more information
	    handlers = {},

	    ensure_installed = {}
	}

	-- Dap UI setup
	-- For more information, see |:help nvim-dap-ui|
	dapui.setup {
	    -- Set icons to characters that are more likely to work in every terminal.
	    --    Feel free to remove or use ones that you like more! :)
	    --    Don't feel like these are good choices.
	    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
	    controls = {
		icons = {
		pause = '⏸',
		play = '▶',
		step_into = '⏎',
		step_over = '⏭',
		step_out = '⏮',
		step_back = 'b',
		run_last = '▶▶',
		terminate = '⏹',
		disconnect = '⏏',
		},
	    },
	}

	dap.listeners.after.event_initialized['dapui_config'] = dapui.open
	dap.listeners.before.event_terminated['dapui_config'] = dapui.close
	dap.listeners.before.event_exited['dapui_config'] = dapui.close

	-- Configure for C++
	dap.adapters.gdb = {
	    type = "executable",
	    command = "gdb",
	    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
	}
	dap.configurations.c = {
	    {
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
		    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	    },
	    {
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = function()
		    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		pid = function()
		local name = vim.fn.input('Executable name (filter): ')
		    return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = '${workspaceFolder}'
	    },
	    {
		name = 'Attach to gdbserver :1234',
		type = 'gdb',
		request = 'attach',
		target = 'localhost:1234',
		    program = function()
		return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}'
	    },
	}
	dap.configurations.c = dap.configurations.cpp
    end
}
