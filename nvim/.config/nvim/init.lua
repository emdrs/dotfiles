vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

-- Some basic configs

vim.o.undofile = true      -- Undo even if close neovim
vim.o.number = true        -- Show numbers in lines
vim.o.tabstop = 4          -- A TAB character looks like 4 spaces
vim.o.expandtab = true     -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4      -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4       -- Number of spaces inserted when indenting
vim.o.colorcolumn = "88"   -- Set a different color to the column 88 of each line
vim.o.ignorecase = true    -- Find text will not be case sensitive
vim.o.scrolloff = 20

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Close search highlight

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

local pack = vim.pack

-- Plenary | Plugin toolkit | Some plugins depends on it
pack.add {{ name = "plenary", src = "https://github.com/nvim-lua/plenary.nvim" }}

-- Catppuccin | Colorscheme
pack.add {{ name = "catppuccin", src = "https://github.com/catppuccin/nvim" }}

vim.cmd.colorscheme "catppuccin-nvim"

-- Oil | File explorer

pack.add {{ name = "oil", src = "https://github.com/stevearc/oil.nvim" }}

require("oil").setup {
    default_file_explorer = true,
    delete_to_trash = true,
    columns = { "permissions", "size", "mtime" },
    skip_confirm_for_simple_edits = true,
    view_options = { show_hidden = true },
    use_default_keymaps = false,
    keymaps = {
        ["<CR>"] = "actions.select", -- Select with enter.
        ["-"] = { "actions.parent", mode = "n" },
    }
}

keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Neogit | Tool to handle git

pack.add {{ name = "neogit", src = "https://github.com/NeogitOrg/neogit" }}

require("neogit").setup {
    kind ="floating",
    commit_editor = {
        kind = "floating",
        show_staged_diff = true,
        spell_check = true,
    }
}

keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")

NEOGIT_DIR = require("oil").get_current_dir()

keymap.set("n", "<leader>cwd", function()
    NEOGIT_DIR = require("oil").get_current_dir()
    if not NEOGIT_DIR then
        NEOGIT_DIR = vim.fn.expand("%:p:h")
    end
    print("Neogit Working Directory setted to", NEOGIT_DIR)
end, { desc = "Change neogit working directory" })

keymap.set({"n", "v"}, "<leader>gg", function ()
    require("neogit").open({ cwd=NEOGIT_DIR })
end, { desc = "Show Neogit UI" })

-- Vim Tmux Navigator | Easy navigation between neovim windows and tmux panels

pack.add {{ name="vim-tmux-navigator", src = "https://github.com/christoomey/vim-tmux-navigator" }}

-- Treesitter | Better code highlight

pack.add {{ name = "treesitter", src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" }}

local parser_install_dir = vim.fn.stdpath('data') .. '/site'
vim.opt.runtimepath:prepend(parser_install_dir)

local treesitter = require('nvim-treesitter')
treesitter.setup {
    install_dir = parser_install_dir,
}

function get_buffer_lang()
    local ft = vim.bo.filetype
    return vim.treesitter.language.get_lang(ft) or ft
end

function print_buffer_lang()
    print(get_buffer_lang())
end

-- Criamos uma função global para o Vim conseguir ler
_G.my_statusline_lang = get_buffer_lang

-- %f = nome arquivo, %m = modificado, %= = separa esquerda/direita
vim.opt.statusline = "%f %m %= %l,%c %{v:lua.get_buffer_lang()} %y"

vim.api.nvim_create_autocmd('FileType', {
    pattern = { "*" },
    callback = function()
        local lang = get_buffer_lang()

        for _, installed_lang in ipairs(treesitter.get_installed()) do
            if lang == installed_lang then
                vim.treesitter.start()
                return
            end
        end
    end
})

vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Handle nvim-treesitter updates',
    group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
    callback = function(event)
        if event.data.kind == 'update' and event.data.spec.name == 'nvim-treesitter' then
            vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok = pcall(vim.cmd, 'TSUpdate')
            if ok then
                vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
            else
                vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
            end
        end
    end,
})

-- Multicursor | Enable multicursors

pack.add{{ name="multiple-cursor", src="https://github.com/brenton-leighton/multiple-cursors.nvim" }}

local mc = require("multiple-cursors").setup {
    remove_in_opposite_direction = false,
}

keymap.set({"n", "x"}, "<A-down>", "<cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor and move down" })
keymap.set({"n", "x"}, "<A-up>", "<cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor and move up" })
keymap.set({"n", "x"}, "<leader>a", "<cmd>MultipleCursorsAddMatches<CR>", { desc = "Add cursors to cword" })
keymap.set({"n", "x"}, "<leader>n", "<cmd>MultipleCursorsAddJumpNextMatch<CR>", { desc = "Add cursor and jump to next cword" })
keymap.set({"n", "x"}, "<leader>s", "<cmd>MultipleCursorsJumpNextMatch<CR>", { desc = "Jump to next cword" })
keymap.set({"n", "x"}, "<leader>l", "<cmd>MultipleCursorsLock<CR>", { desc = "Lock virtual cursors" })

-- Live Server | Hot reload to web project

pack.add {{ name="live-server", src="https://github.com/ngtuonghy/live-server-nvim" }}

require("live-server-nvim").setup {
    custom = {
        "--port=8080",
        "--no-css-inject",
    },
    serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
    open = "folder", -- folder|cwd     --default
}

-- Telescope | Fuzzy finder trought files.

pack.add {
    { src="https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
    { name="telescope", src="https://github.com/nvim-telescope/telescope.nvim" }
}

local telescope = require("telescope")
telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
telescope.load_extension("fzf") -- You need to build the project manually in pack folder download

local telescope_builtin = require("telescope.builtin")

keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
keymap.set("n", "<leader>fg", telescope_builtin.live_grep,  { desc = "Telescope live grep"  })
keymap.set("n", "<leader>fb", telescope_builtin.buffers,    { desc = "Telescope buffers"    })
keymap.set("n", "<leader>fh", telescope_builtin.help_tags,  { desc = "Telescope help tags"  })

-- Compile mode | Add a compile mode thats can run commands from neovim.

pack.add {{ name="compile-mode", src="https://github.com/ej-shafran/compile-mode.nvim" }}

keymap.set("n", "<leader>cc", "<cmd>Compile<CR>")

vim.g.compile_mode = {
    default_command = "make -C build/",
    focus_compilation_buffer = true,
}

-- ScrollEOF | Add blank spaces before EOF.

pack.add{{ name="scrollBeforeEOF", src="https://github.com/emdrs/scrollBeforeEOF" }}

require("scrollBeforeEOF").setup()

-- VimTeX | Support to latex

pack.add{{ name="vimtex", src="https://github.com/lervag/vimtex" }}

vim.g.vimtex_view_method = "skim"
