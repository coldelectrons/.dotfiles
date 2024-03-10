--[[
`lvim` is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- general
lvim.log.level = "warn"
lvim.format_on_save = {
	enabled = true,
	pattern = "*.lua",
	timeout = 1000,
}
-- lvim.lsp.diagnostic.config({ virtual_text = true })
vim.diagnostic.config({ virtual_text = true })
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false
vim.g.use_nerd_icons = true

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
lvim.builtin.which_key.mappings["z"] = {
	name = "+Telekasten",
	f = { "<cmd>Telekasten find_notes<cr>", "find notes" },
	d = { "<cmd>Telekasten find_daily_notes<cr>", "find daily notes" },
	g = { "<cmd>Telekasten search_notes<cr>", "search notes" },
	z = { "<cmd>Telekasten follow_link<cr>", "follow link" },
	T = { "<cmd>Telekasten goto_today<cr>", "go to note for today" },
	W = { "<cmd>Telekasten goto_thisweek<cr>", "go to note for this week" },
	w = { "<cmd>Telekasten find_weekly_notes<cr>", "find weekly notes" },
	n = { "<cmd>Telekasten new_note<cr>", "new note" },
	N = { "<cmd>Telekasten new_templated_note<cr>", "new templated note" },
	y = { "<cmd>Telekasten yank_notelink<cr>", "yank notelink" },
	c = { "<cmd>Telekasten show_calendar<cr>", "show calendar" },
	C = { "<cmd>CalendarT<cr>", "SHOW CALENDAR" },
	i = { "<cmd>Telekasten paste_img_and_link<cr>", "paste image and link from clipboard" },
	t = { "<cmd>Telekasten toggle_todo<cr>", "toggle todo" },
	b = { "<cmd>Telekasten show_backlinks<cr>", "show backlinks" },
	F = { "<cmd>Telekasten find_friends<cr>", "find friends" },
	I = { "<cmd>Telekasten insert_img_link<cr>", "insert image link" },
	p = { "<cmd>Telekasten preview_img<cr>", "preview image" },
	m = { "<cmd>Telekasten browse_media<cr>", "browse media" },
	s = { "<cmd>Telekasten show_tags<cr>", "show tags" },
	v = { "<cmd>Telekasten switch_vault<cr>", "switch vault" },
	Z = { "<cmd>Telekasten panel<cr>", "command palette panel" },
}
lvim.builtin.which_key.mappings["r"] = {
	name = "+IronRepl",
	s = { "<cmd>IronRepl<cr>", "open repl" },
	r = { "<cmd>IronRestart<cr>", "restart repl" },
	f = { "<cmd>IronFocus<cr>", "focus on repl" },
	h = { "<cmd>IronHide<cr>", "hide repl" },
}

lvim.keys.normal_mode["s"] = ":HopChar2<cr>"
lvim.keys.normal_mode["S"] = ":HopWord<cr>"
lvim.builtin.which_key.mappings["H"] = {
	name = "+Hop",
	f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "hop after cursor on current line" },
	F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "hop before cursor on current line" },
	t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", "hop after cursor on current line" },
	T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", "hop before cursor on current line" },
}

-- -- Change theme settings
lvim.colorscheme = "tokyodark"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex", "python" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })

local clangd_flags = {
	"--fallback-style=LLVM",
	"--background-index",
	"-j=12",
	"--all-scopes-completion",
	"--pch-storage=disk",
	"--clang-tidy",
	"--log=error",
	"--completion-style=detailed",
	"--header-insertion=iwyu",
	"--header-insertion-decorators",
	"--enable-config",
	"--offset-encoding=utf-16",
	"--ranking-model=heuristics",
	"--folding-ranges",
}

local clangd_bin = "clangd"

local opts = {
	cmd = { clangd_bin, unpack(clangd_flags) },
}
require("lvim.lsp.manager").setup("clangd", opts)

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "stylua" },
	{ name = "black" },
	--   {
	--     command = "prettier",
	--     extra_args = { "--print-width", "100" },
	--     filetypes = { "typescript", "typescriptreact" },
	--   },
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "flake8", args = { "--ignore=E203" }, filetypes = { "python" } },
	--   {
	--     command = "shellcheck",
	--     args = { "--severity", "warning" },
	--   },
})

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
	{ "folke/tokyonight.nvim" },
  { "tiagovla/tokyodark.nvim" },
  { "EdenEast/nightfox.nvim" },
	{ "catppuccin/nvim", lazy = true, name = "catppuccin", priority = 1000 },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	-- misc little things
	{ "pbrisbin/vim-mkdir" },
	-- And so it goes, I hear motion
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup()
		end,
	},
	-- the obligatory writing mode
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
					-- height and width can be:
					-- * an absolute number of cells when > 1
					-- * a percentage of the width / height of the editor when <= 1
					-- * a function that returns the width or the height
					width = 120, -- width of the Zen window
					height = 1, -- height of the Zen window
					-- by default, no options are changed for the Zen window
					-- uncomment any of the options below, or add other vim.wo options you want to apply
					options = {
						-- signcolumn = "no", -- disable signcolumn
						-- number = false, -- disable number column
						-- relativenumber = false, -- disable relative numbers
						-- cursorline = false, -- disable cursorline
						-- cursorcolumn = false, -- disable cursor column
						-- foldcolumn = "0", -- disable fold column
						-- list = false, -- disable whitespace characters
					},
				},
				plugins = {
					-- disable some global vim options (vim.o...)
					-- comment the lines to not apply the options
					options = {
						enabled = true,
						ruler = false, -- disables the ruler text in the cmd line area
						showcmd = false, -- disables the command in the last line of the screen
					},
					twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
					gitsigns = { enabled = false }, -- disables git signs
					tmux = { enabled = false }, -- disables the tmux statusline
					-- this will change the font size on kitty when in zen mode
					-- to make this work, you need to set the following kitty options:
					-- - allow_remote_control socket-only
					-- - listen_on unix:/tmp/kitty
					kitty = {
						enabled = true,
						font = "+4", -- font size increment
					},
				},
				-- callback where you can add custom code when the Zen window opens
				on_open = function(win) end,
				-- callback where you can add custom code when the Zen window closes
				on_close = function() end,
			})
		end,
	},
	{ "renerocksai/calendar-vim" },
	{ "nvim-telescope/telescope-media-files.nvim" },
	{ "nvim-telescope/telescope-symbols.nvim" },
	{
		"renerocksai/telekasten.nvim",
		dependencies = {
			"nvim-lua/popup.nvim", -- already in lunarvim
			"nvim-lua/plenary.nvim", -- already in lunarvim
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"renerocksai/calendar-vim",
			"nvim-telescope/telescope-symbols.nvim",
		},
	},
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " .. vim.fn.expand "~" .. "vaults/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "vaults/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "writing",
          path = "~/vaults/writing",
        },
        {
          name = "personal",
          path = "~/vaults/personal",
        },
        {
          name = "work",
          path = "~/vaults/work",
        },
      },
    },
  },
	{
		"kevinhwang91/nvim-bqf",
		event = { "BufRead", "BufNew" },
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"kevinhwang91/rnvimr",
		cmd = "RnvimrToggle",
		config = function()
			vim.g.rnvimr_draw_border = 1
			vim.g.rnvimr_pick_enable = 1
			vim.g.rnvimr_bw_enable = 1
		end,
	},
	{
		"camspiers/snap",
		config = function()
			local snap = require("snap")
			local layout = snap.get("layout").bottom
			local file = snap.config.file:with({ consumer = "fzf", layout = layout })
			local vimgrep = snap.config.vimgrep:with({ layout = layout })
			snap.register.command("find_files", file({ producer = "ripgrep.file" }))
			snap.register.command("buffers", file({ producer = "vim.buffer" }))
			snap.register.command("oldfiles", file({ producer = "vim.oldfile" }))
			snap.register.command("live_grep", vimgrep({}))
		end,
	},
	{
		"andymass/vim-matchup",
		event = "CursorMoved",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufRead",
	},
	-- {
	--     "p00f/nvim-ts-rainbow",
	-- },
	{
		"nvim-treesitter/playground",
		event = "BufRead",
	},
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-project.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		event = "BufWinEnter",
		-- setup = function()
		-- vim.cmd [[packadd telescope.nvim]]
		-- end,
	},
	-- {
	--   "zbirenbaum/copilot.lua",
	--   cmd = "Copilot",
	--   event = "InsertEnter",
	-- },
	-- {
	--   "zbirenbaum/copilot-cmp",
	--   after = { "copilot.lua" },
	--   config = function()
	--     require("copilot_cmp").setup()
	--   end,
	-- },
	{ "Vigemus/iron.nvim" },
	-- { "akinsho/toggleterm.nvim", version = "*", config = true },
	-- { "voldikss/vim-floaterm" },
	-- {
	-- 	"jghauser/kitty-runner.nvim",
	-- 	config = function()
	-- 		require("kitty-runner").setup()
	-- 	end,
	-- },
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	"ChristianChiarulli/swenv.nvim",
	"stevearc/dressing.nvim",
}

lvim.builtin.which_key.mappings["C"] = {
	name = "Python",
	c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}

require("swenv").setup({
	post_set_venv = function()
		vim.cmd("LspRestart")
	end,
})

local iron = require("iron.core")
iron.setup({
	config = {
		-- Whether a repl should be discarded or not
		scratch_repl = false,
		-- Your repl definitions come here
		repl_definition = {
			sh = {
				-- Can be a table or a function that
				-- returns a table (see below)
				command = { "zsh" },
			},
		},
		-- How the repl window will be displayed
		-- See below for more information
		repl_open_cmd = require("iron.view").bottom(40),
	},
	-- Iron doesn't set keymaps by default anymore.
	-- You can set them here or manually add keymaps to the functions in iron.core
	-- keymaps = {
	--   send_motion = "<space>sc",
	--   visual_send = "<space>sc",
	--   send_file = "<space>sf",
	--   send_line = "<space>sl",
	--   send_until_cursor = "<space>su",
	--   send_mark = "<space>sm",
	--   mark_motion = "<space>mc",
	--   mark_visual = "<space>mc",
	--   remove_mark = "<space>md",
	--   cr = "<space>s<cr>",
	--   interrupt = "<space>s<space>",
	--   exit = "<space>sq",
	--   clear = "<space>cl",
	-- },
	-- If the highlight is on, you can change how it looks
	-- For the available options, check nvim_set_hl
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")

local opts = { noremap = true, silent = true }

require("obsidian").setup( {
  -- A list of workspace names, paths, and configuration overrides.
  -- If you use the Obsidian app, the 'path' of a workspace should generally be
  -- your vault root (where the `.obsidian` folder is located).
  -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
  -- the workspace to the first workspace in the list whose `path` is a parent of the
  -- current markdown file being edited.
  workspaces = {
    {
      name = "personal",
      path = "~/vaults/personal",
    },
    {
      name = "work",
      path = "~/vaults/work",
      -- Optional, override certain settings.
      overrides = {
        notes_subdir = "notes",
      },
    },
  },

  -- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
  -- 'workspaces'. For example:
  -- dir = "~/vaults/work",

  -- Optional, if you keep notes in a specific subdirectory of your vault.
  notes_subdir = "notes",

  -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
  -- levels defined by "vim.log.levels.*".
  log_level = vim.log.levels.INFO,

  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "notes/dailies",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = nil
  },

  -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    -- Trigger completion at 2 chars.
    min_chars = 2,
  },

  -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
  -- way then set 'mappings = {}'.
  mappings = {
    -- -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    -- ["gf"] = {
    --   action = function()
    --     return require("obsidian").util.gf_passthrough()
    --   end,
    --   opts = { noremap = false, expr = true, buffer = true },
    -- },
    -- -- Toggle check-boxes.
    -- ["<leader>ch"] = {
    --   action = function()
    --     return require("obsidian").util.toggle_checkbox()
    --   end,
    --   opts = { buffer = true },
    -- },
  },

  -- Where to put new notes. Valid options are
  --  * "current_dir" - put new notes in same directory as the current buffer.
  --  * "notes_subdir" - put new notes in the default notes subdirectory.
  new_notes_location = "notes_subdir",

  -- Optional, customize how note IDs are generated given an optional title.
  ---@param title string|?
  ---@return string
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,

  -- Optional, customize how note file names are generated given the ID, target directory, and title.
  ---@param spec { id: string, dir: obsidian.Path, title: string|? }
  ---@return string|obsidian.Path The full path to the new note.
  note_path_func = function(spec)
    -- This is equivalent to the default behavior.
    local path = spec.dir / tostring(spec.id)
    return path:with_suffix(".md")
  end,

  -- Optional, customize how wiki links are formatted. You can set this to one of:
  --  * "use_alias_only", e.g. '[[Foo Bar]]'
  --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
  --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
  --  * "use_path_only", e.g. '[[foo-bar.md]]'
  -- Or you can set it to a function that takes a table of options and returns a string, like this:
  wiki_link_func = function(opts)
    return require("obsidian.util").wiki_link_id_prefix(opts)
  end,

  -- Optional, customize how markdown links are formatted.
  markdown_link_func = function(opts)
    return require("obsidian.util").markdown_link(opts)
  end,

  -- Either 'wiki' or 'markdown'.
  preferred_link_style = "wiki",

  -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
  ---@return string
  image_name_func = function()
    -- Prefix image names with timestamp.
    return string.format("%s-", os.time())
  end,

  -- Optional, boolean or a function that takes a filename and returns a boolean.
  -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
  disable_frontmatter = false,

  -- Optional, alternatively you can customize the frontmatter data.
  ---@return table
  note_frontmatter_func = function(note)
    -- Add the title of the note as an alias.
    if note.title then
      note:add_alias(note.title)
    end

    local out = { id = note.id, aliases = note.aliases, tags = note.tags }

    -- `note.metadata` contains any manually added fields in the frontmatter.
    -- So here we just make sure those fields are kept in the frontmatter.
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end

    return out
  end,

  -- Optional, for templates (see below).
  templates = {
    subdir = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- A map for custom variables, the key should be the variable and the value a function
    substitutions = {},
  },

  -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
  -- URL it will be ignored but you can customize this behavior here.
  ---@param url string
  follow_url_func = function(url)
    -- Open the URL in the default web browser.
    vim.fn.jobstart({"open", url})  -- Mac OS
    -- vim.fn.jobstart({"xdg-open", url})  -- linux
  end,

  -- Optional, set to true if you use the Obsidian Advanced URI plugin.
  -- https://github.com/Vinzent03/obsidian-advanced-uri
  use_advanced_uri = false,

  -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
  open_app_foreground = false,

  picker = {
    -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
    name = "telescope.nvim",
    -- Optional, configure key mappings for the picker. These are the defaults.
    -- Not all pickers support all mappings.
    mappings = {
      -- Create a new note from your query.
      new = "<C-x>",
      -- Insert a link to the selected note.
      insert_link = "<C-l>",
    },
  },

  -- Optional, sort search results by "path", "modified", "accessed", or "created".
  -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
  -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
  sort_by = "modified",
  sort_reversed = true,

  -- Optional, determines how certain commands open notes. The valid options are:
  -- 1. "current" (the default) - to always open in the current window
  -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
  -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
  open_notes_in = "current",

  -- Optional, define your own callbacks to further customize behavior.
  callbacks = {
    -- Runs at the end of `require("obsidian").setup()`.
    ---@param client obsidian.Client
    post_setup = function(client) end,

    -- Runs anytime you enter the buffer for a note.
    ---@param client obsidian.Client
    ---@param note obsidian.Note
    enter_note = function(client, note) end,

    -- Runs anytime you leave the buffer for a note.
    ---@param client obsidian.Client
    ---@param note obsidian.Note
    leave_note = function(client, note) end,

    -- Runs right before writing the buffer for a note.
    ---@param client obsidian.Client
    ---@param note obsidian.Note
    pre_write_note = function(client, note) end,

    -- Runs anytime the workspace is set/changed.
    ---@param client obsidian.Client
    ---@param workspace obsidian.Workspace
    post_set_workspace = function(client, workspace) end,
  },

  -- Optional, configure additional syntax highlighting / extmarks.
  -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
  ui = {
    enable = true,  -- set to false to disable all additional syntax features
    update_debounce = 200,  -- update delay after a text change (in milliseconds)
    -- Define how various check-boxes are displayed
    checkboxes = {
      -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = "", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      -- Replace the above with this if you don't have a patched font:
      -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
      -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

      -- You can also add more custom ones...
    },
    -- Use bullet marks for non-checkbox lists.
    bullets = { char = "•", hl_group = "ObsidianBullet" },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    -- Replace the above with this if you don't have a patched font:
    -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    block_ids = { hl_group = "ObsidianBlockID" },
    hl_groups = {
      -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianBullet = { bold = true, fg = "#89ddff" },
      ObsidianRefText = { underline = true, fg = "#c792ea" },
      ObsidianExtLinkIcon = { fg = "#c792ea" },
      ObsidianTag = { italic = true, fg = "#89ddff" },
      ObsidianBlockID = { italic = true, fg = "#89ddff" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },

  -- Specify how to handle attachments.
  attachments = {
    -- The default folder to place images in via `:ObsidianPasteImg`.
    -- If this is a relative path it will be interpreted as relative to the vault root.
    -- You can always override this per image by passing a full path to the command instead of just a filename.
    img_folder = "assets/imgs",  -- This is the default
    -- A function that determines the text to insert in the note when pasting an image.
    -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
    -- This is the default implementation.
    ---@param client obsidian.Client
    ---@param path obsidian.Path the absolute path to the image file
    ---@return string
    img_text_func = function(client, path)
      local link_path
      local vault_relative_path = client:vault_relative_path(path)
      if vault_relative_path ~= nil then
        -- Use relative path if the image is saved in the vault dir.
        link_path = vault_relative_path
      else
        -- Otherwise use the absolute path.
        link_path = tostring(path)
      end
      local display_name = vim.fs.basename(link_path)
      return string.format("![%s](%s)", display_name, link_path)
    end,
  },
})

local home = vim.fn.expand("~/zk") -- have to manually make the folder
-- local home = require('plenary.path'):new("~/zettelkasten"):normalize()
-- local home = '/home/thomas/zettelkasten'
require("telekasten").setup({
	home = home,

	-- if true, telekasten will be enabled when opening a note within the configured home
	take_over_my_home = true,

	-- auto-set telekasten filetype: if false, the telekasten filetype will not be used
	--                               and thus the telekasten syntax will not be loaded either
	auto_set_filetype = true,

	-- dir names for special notes (absolute path or subdir name)
	dailies = home .. "/" .. "daily",
	weeklies = home .. "/" .. "weekly",
	templates = home .. "/" .. "templates",

	-- image (sub)dir for pasting
	-- dir name (absolute path or subdir name)
	-- or nil if pasted images shouldn't go into a special subdir
	image_subdir = "img",

	-- markdown file extension
	extension = ".md",

	-- Generate note filenames. One of:
	-- "title" (default) - Use title if supplied, uuid otherwise
	-- "uuid" - Use uuid
	-- "uuid-title" - Prefix title by uuid
	-- "title-uuid" - Suffix title with uuid
	new_note_filename = "title",
	-- file uuid type ("rand" or input for os.date()")
	uuid_type = "%Y%m%d%H%M",
	-- UUID separator
	uuid_sep = "-",

	-- following a link to a non-existing note will create it
	follow_creates_nonexisting = true,
	dailies_create_nonexisting = true,
	weeklies_create_nonexisting = true,

	-- skip telescope prompt for goto_today and goto_thisweek
	journal_auto_open = false,

	-- template for new notes (new_note, follow_link)
	-- set to `nil` or do not specify if you do not want a template
	template_new_note = home .. "/" .. "templates/new_note.md",

	-- template for newly created daily notes (goto_today)
	-- set to `nil` or do not specify if you do not want a template
	template_new_daily = home .. "/" .. "templates/daily.md",

	-- template for newly created weekly notes (goto_thisweek)
	-- set to `nil` or do not specify if you do not want a template
	template_new_weekly = home .. "/" .. "templates/weekly.md",

	-- image link style
	-- wiki:     ![[image name]]
	-- markdown: ![](image_subdir/xxxxx.png)
	image_link_style = "markdown",

	-- default sort option: 'filename', 'modified'
	sort = "filename",

	-- integrate with calendar-vim
	plug_into_calendar = true,
	calendar_opts = {
		-- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
		weeknm = 4,
		-- use monday as first day of week: 1 .. true, 0 .. false
		calendar_monday = 1,
		-- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
		calendar_mark = "left-fit",
	},

	-- telescope actions behavior
	close_after_yanking = false,
	insert_after_inserting = true,

	-- tag notation: '#tag', ':tag:', 'yaml-bare'
	tag_notation = "#tag",

	-- command palette theme: dropdown (window) or ivy (bottom panel)
	command_palette_theme = "ivy",

	-- tag list theme:
	-- get_cursor: small tag list at cursor; ivy and dropdown like above
	show_tags_theme = "ivy",

	-- when linking to a note in subdir/, create a [[subdir/title]] link
	-- instead of a [[title only]] link
	subdirs_in_links = true,

	-- template_handling
	-- What to do when creating a new note via `new_note()` or `follow_link()`
	-- to a non-existing note
	-- - prefer_new_note: use `new_note` template
	-- - smart: if day or week is detected in title, use daily / weekly templates (default)
	-- - always_ask: always ask before creating a note
	template_handling = "smart",

	-- path handling:
	--   this applies to:
	--     - new_note()
	--     - new_templated_note()
	--     - follow_link() to non-existing note
	--
	--   it does NOT apply to:
	--     - goto_today()
	--     - goto_thisweek()
	--
	--   Valid options:
	--     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
	--              all other ones in home, except for notes/with/subdirs/in/title.
	--              (default)
	--
	--     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
	--                    except for notes with subdirs/in/title.
	--
	--     - same_as_current: put all new notes in the dir of the current note if
	--                        present or else in home
	--                        except for notes/with/subdirs/in/title.
	new_note_location = "smart",

	-- should all links be updated when a file is renamed
	rename_update_links = true,
})

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
