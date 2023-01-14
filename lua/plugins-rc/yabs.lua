local yabs = safe_require("yabs")
if not yabs then
	return
end

local telescope = safe_require("telescope")
if not telescope then
	return
end

local c_config = {
	default_task = "build_and_run",
	tasks = {
		build = {
			command = "gcc main.c -o main",
			output = "quickfix", -- Where to show output of the
			-- command. Can be `buffer`,
			-- `consolation`, `echo`,
			-- `quickfix`, `terminal`, or `none`
			opts = { -- Options for output (currently, there's only
				-- `open_on_run`, which defines the behavior
				-- for the quickfix list opening) (can be
				-- `never`, `always`, or `auto`, the default)
				open_on_run = "always",
			},
		},
		run = { -- You can specify as many tasks as you want per
			-- filetype
			command = "./main",
			output = "consolation",
		},
		build_and_run = { -- Setting the type to lua means the command
			-- is a lua function
			command = function()
				-- The following api can be used to run a task when a
				-- previous one finishes
				-- WARNING: this api is experimental and subject to
				-- changes
				require("yabs"):run_task("build", {
					-- Job here is a plenary.job object that represents
					-- the finished task, read more about it here:
					-- https://github.com/nvim-lua/plenary.nvim#plenaryjob
					on_exit = function(Job, exit_code)
						-- The parameters `Job` and `exit_code` are optional,
						-- you can omit extra arguments or
						-- skip some of them using _ for the name
						if exit_code == 0 then
							require("yabs").languages.c:run_task("run")
						end
					end,
				})
			end,
			type = "lua",
		},
	},
}

local lua_config = {
	tasks = {
		run = {
			command = "lua %", -- The command to run (% and other
			-- wildcards will be automatically
			-- expanded)
			type = "lua", -- The type of command (can be `vim`, `lua`, or
			-- `shell`, default `shell`)
		},
	},
}

local python_config = {
	default_task = "run",
	tasks = {
		build = { command = "python %", output = "terminal" },
		run = { command = "python %", output = "terminal" },
		lint = { command = "pylint %", output = "terminal" },
	},
}

yabs:setup({
	languages = { -- List of languages in vim's `filetype` format
		lua = lua_config,
		python = python_config,
		c = c_config,
	},
	tasks = { -- Same values as `language.tasks`, but global
		build = { command = "echo building project...", output = "terminal" },
		run = { command = "echo running project...", output = "echo" },
		optional = {
			command = "echo runs on condition",
			-- You can specify a condition which determines whether to enable a
			-- specific task
			-- It should be a function that returns boolean,
			-- not a boolean directly
			-- Here we use a helper from yabs that returns such function
			-- to check if the files exists
			condition = require("yabs.conditions").file_exists("filename.txt"),
		},
	},
	opts = { -- Same values as `language.opts`
		output_types = { quickfix = { open_on_run = "always" } },
	},
})

telescope.load_extension("yabs")
