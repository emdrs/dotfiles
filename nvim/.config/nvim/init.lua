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
vim.keymap.set({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>")

----------------------------------------------------------------------------------------
--- Plugins
----------------------------------------------------------------------------------------

local pack = vim.pack

-- Catppuccin | Colorscheme
pack.add { { name = "catppuccin", src = "https://github.com/catppuccin/nvim" } }
vim.cmd.colorscheme "catppuccin-nvim"

-- opencode.nvim | AI code assistant
pack.add { { name = "opencode.nvim", src = "https://github.com/nickjvandyke/opencode.nvim" } }

vim.g.opencode_opts = {}

vim.o.autoread = true

vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<C-U>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
vim.keymap.set("n", "<C-D>", function() require("opencode").command("session.half.page.down") end,   { desc = "Scroll opencode down" })

-- Neogit | Git interface
pack.add { { name = "neogit", src = "https://github.com/NeogitOrg/neogit" } }

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

vim.keymap.set("n", "<leader>gg",
    function() require("neogit").open({ kind = "floating" }) end,
    { desc = "Open Neogit" })

-- nvim-tmux-navigation | Navigate between nvim and tmux panes
pack.add { { name = "nvim-tmux-navigation", src = "https://github.com/alexghergh/nvim-tmux-navigation" } }

local nvim_tmux_nav = require("nvim-tmux-navigation")
nvim_tmux_nav.setup {
  disable_when_zoomed = true,
}

vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

-- scrollBeforeEOF | Keep scrolloff at bottom of file
pack.add { { name = "scrollBeforeEOF", src = "https://github.com/emdrs/scrollBeforeEOF" } }
require("scrollBeforeEOF").setup()

-- oil.nvim | File explorer
pack.add { { name = "oil.nvim", src = "https://github.com/stevearc/oil.nvim" } }
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

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open oil file explorer" })

-- multiple-cursors.nvim | Multiple cursors
pack.add { { name = "multiple-cursors.nvim", src = "https://github.com/brenton-leighton/multiple-cursors.nvim" } }

require("multiple-cursors").setup {
    remove_in_opposite_direction = false,
}

vim.keymap.set("n", "<A-Up>",    "<cmd>MultipleCursorsAddUp<CR>",            { desc = "Add cursor up" })
vim.keymap.set("n", "<A-Down>",  "<cmd>MultipleCursorsAddDown<CR>",          { desc = "Add cursor down" })
vim.keymap.set("n", "<leader>a", "<cmd>MultipleCursorsAddMatches<CR>",       { desc = "Select all matches" })
vim.keymap.set("n", "<leader>n", "<cmd>MultipleCursorsAddJumpNextMatch<CR>", { desc = "Add cursor at next match" })
vim.keymap.set("n", "<leader>p", "<cmd>MultipleCursorsAddJumpPrevMatch<CR>", { desc = "Add cursor at previous match" })

-- plenary.nvim | Dependency for telescope
pack.add { { name = "plenary.nvim", src = "https://github.com/nvim-lua/plenary.nvim" } }

-- telescope.nvim | Fuzzy finder
pack.add { { name = "telescope.nvim", src = "https://github.com/nvim-telescope/telescope.nvim" } }
pack.add { { name = "telescope-fzf-native.nvim", src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" } }

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

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",   { desc = "Recent files" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<CR>",   { desc = "Commands" })
