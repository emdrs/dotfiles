vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

-- Some basic configs

vim.o.undofile = true    -- Undo even if close neovim
vim.o.number = true      -- Show numbers in lines
vim.o.tabstop = 4        -- A TAB character looks like 4 spaces
vim.o.expandtab = true   -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4    -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4     -- Number of spaces inserted when indenting
vim.o.colorcolumn = "88" -- Set a different color to the column 88 of each line
vim.o.ignorecase = true  -- Find text will not be case sensitive
vim.o.scrolloff = 20

vim.g.c_syntax_for_h = 1 -- Detect .h as c, not cpp

vim.opt.laststatus = 3   -- Set statusline to unique and global

local status_addon = " %{v:lua.get_buffer_lang()}"
local current_status = vim.opt.statusline:get()

if not string.find(current_status, "get_buffer_lang", 1, true) then
  vim.opt.statusline:append(status_addon)
end

function get_buffer_lang()
    local ft = vim.bo.filetype
    return vim.treesitter.language.get_lang(ft) or ft
end

-- Aliases
vim.cmd([[
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qa qa
    cnoreabbrev Qa! qa!
    cnoreabbrev QA! qa!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev WA wa
    cnoreabbrev WQ wq
    cnoreabbrev Wqa wqa
    cnoreabbrev WQa wqa
]])

-- Keymaps
keymap.set({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>") -- Clear search

keymap.set("n", "<leader>cd", function() -- Change working directory (neogit, telescope)
    local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
    if buf_dir ~= "" then
        vim.fn.chdir(buf_dir)
        print("new cwd: " .. buf_dir)
    end
end, { desc = "Change cwd to buffer's directory" })

----------------------------------------------------------------------------------------
--- Plugins
----------------------------------------------------------------------------------------

local pack = vim.pack

-- Catppuccin | Colorscheme
pack.add { { src = "https://github.com/catppuccin/nvim" } }
vim.cmd.colorscheme "catppuccin-nvim"

-- opencode.nvim | AI code assistant
pack.add { { src = "https://github.com/nickjvandyke/opencode.nvim" } }

vim.g.opencode_opts = {}

vim.o.autoread = true

keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

keymap.set("n", "<C-U>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
keymap.set("n", "<C-D>", function() require("opencode").command("session.half.page.down") end,   { desc = "Scroll opencode down" })

-- Neogit | Git interface
pack.add { { src = "https://github.com/NeogitOrg/neogit" } }

require("neogit").setup {
  disable_line_numbers = true,
  disable_relative_line_numbers = true,
  kind = "floating",
  commit_editor = { kind = "floating" },
  commit_select_view = { kind = "floating" },
  commit_view = { kind = "floating" },
  log_view = { kind = "floating" },
  rebase_editor = { kind = "floating" },
  reflog_view = { kind = "floating" },
  merge_editor = { kind = "floating" },
  preview_buffer = { kind = "floating" },
  stash = { kind = "floating" },
  refs_view = { kind = "floating" },
  popup = { kind = "floating" },
  status = {
    recent_commit_count = 5,
  },
}

keymap.set("n", "<leader>gg",
    function() require("neogit").open({ kind = "floating" }) end,
    { desc = "Open Neogit" })

-- nvim-tmux-navigation | Navigate between nvim and tmux panes
pack.add { { src = "https://github.com/alexghergh/nvim-tmux-navigation" } }

local nvim_tmux_nav = require("nvim-tmux-navigation")
nvim_tmux_nav.setup {
  disable_when_zoomed = true,
}

keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

-- scrollBeforeEOF | Keep scrolloff at bottom of file
pack.add { { src = "https://github.com/emdrs/scrollBeforeEOF" } }
require("scrollBeforeEOF").setup()

-- oil.nvim | File explorer
pack.add { { src = "https://github.com/stevearc/oil.nvim" } }
require("oil").setup {
    default_file_explorer = true,
    delete_to_trash = true,
    columns = { "permissions", "size", "mtime" },
    skip_confirm_for_simple_edits = true,
    view_options = { show_hidden = true },
    use_default_keymaps = false,
    keymaps = {
        ["<CR>"] = "actions.select",
        ["-"] = { "actions.parent", mode = "n" },
    }
}

keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open oil file explorer" })

-- multiple-cursors.nvim | Multiple cursors
pack.add { { src = "https://github.com/brenton-leighton/multiple-cursors.nvim" } }

require("multiple-cursors").setup {
    remove_in_opposite_direction = false,
}

keymap.set("n", "<A-Up>",    "<cmd>MultipleCursorsAddUp<CR>",            { desc = "Add cursor up" })
keymap.set("n", "<A-Down>",  "<cmd>MultipleCursorsAddDown<CR>",          { desc = "Add cursor down" })
keymap.set("n", "<leader>a", "<cmd>MultipleCursorsAddMatches<CR>",       { desc = "Select all matches" })
keymap.set("n", "<leader>n", "<cmd>MultipleCursorsAddJumpNextMatch<CR>", { desc = "Add cursor at next match" })
keymap.set("n", "<leader>p", "<cmd>MultipleCursorsAddJumpPrevMatch<CR>", { desc = "Add cursor at previous match" })

-- plenary.nvim | Dependency for telescope
pack.add { { src = "https://github.com/nvim-lua/plenary.nvim" } }

-- telescope.nvim | Fuzzy finder
pack.add { { src = "https://github.com/nvim-telescope/telescope.nvim" } }
pack.add { { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" } }

local telescope = require("telescope")
telescope.setup {
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            width = 0.87,
            height = 0.80,
        },
        file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        colorize = true,
    },
}

telescope.load_extension("fzf")

keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live grep" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Buffers" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  { desc = "Help tags" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",   { desc = "Recent files" })
keymap.set("n", "<leader>fc", "<cmd>Telescope commands<CR>",   { desc = "Commands" })

-- vimtex | LaTeX editing
pack.add { { src = "https://github.com/lervag/vimtex" } }

vim.g.vimtex_view_method = "skim"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
    aux_dir = "aux",
    options = {
        "-pdf",
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
    },
}

-- compile-mode.nvim | Run compilation commands
pack.add { { src = "https://github.com/ej-shafran/compile-mode.nvim" } }

vim.g.compile_mode = {
    default_command = "",
    focus_compilation_buffer = true,
}

keymap.set("n", "<leader>cc", "<cmd>Compile<CR>", { desc = "Run compile command" })

-- tree-sitter-manager.nvim | Tree-sitter installation manager
pack.add { { src = "https://github.com/romus204/tree-sitter-manager.nvim" } }

require("tree-sitter-manager").setup()

keymap.set("n", "<leader>tm", "<cmd>TSManager<CR>", { desc = "Show TSManager" })

-- live-server-nvim | Live server for HTML/CSS/JS development
pack.add { { src = "https://github.com/ngtuonghy/live-server-nvim" } }

require("live-server-nvim").setup {
    custom = {
        "--port=8080",
        "--no-css-inject",
    },
 serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
 open = "folder", -- folder|cwd     --default
}

keymap.set("n", "<leader>lt", "<cmd>LiveServerToggle<CR>", { desc = "Show TSManager" })

-- DAP | Debug tool

pack.add { { name="nio",    src="https://github.com/nvim-neotest/nvim-nio" } }
pack.add { { name="dap",    src="https://github.com/mfussenegger/nvim-dap" } }
pack.add { { name="dap-ui", src="https://github.com/rcarriga/nvim-dap-ui"  } }

local dap, dapui = require("dap"), require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited    ["dapui_config"] = dapui.close

keymap.set("n", "<leader>dq", dapui.close)
keymap.set("n", "<leader>dc", dap.continue)
keymap.set("n", "<leader>dn", dap.step_over)
keymap.set("n", "<leader>di", dap.step_into)
keymap.set("n", "<leader>do", dap.step_out)
keymap.set("n", "<leader>db", dap.toggle_breakpoint)
keymap.set("n", "<leader>dT", dap.terminate)
keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
keymap.set("n", "<Leader>dr", dap.repl.open)
keymap.set("n", "<Leader>dl", dap.run_last)

dap.adapters.lldb = {
  type = "executable",
  command = "/opt/homebrew/opt/llvm/bin/lldb-dap", -- adjust as needed, must be absolute path
  name = "lldb"
}

local last_args = {}
local last_program = ""

dap.configurations.c = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
        local default_text = vim.fn.getcwd() .. "/"
        last_program = vim.fn.input("Path to executable: ", last_program == "" and default_text or last_program, "file")
        return last_program
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
        local default_text = table.concat(last_args, " ")
        local args_string = vim.fn.input('Arguments: ', default_text)

        last_args = args_string == "" and {} or vim.split(args_string, " ")

        return last_args
    end,
  },
}

dap.configurations.cpp = dap.configurations.c
