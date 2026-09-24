--------------------------------------------------
-- BASIC EDITOR
--------------------------------------------------
vim.cmd.colorscheme("habamax")
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.signcolumn = "yes"

vim.opt.undofile = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

--------------------------------------------------
-- CLIPBOARD
--------------------------------------------------

vim.opt.clipboard = "unnamedplus"

--------------------------------------------------
-- APPEARANCE
--------------------------------------------------

vim.opt.fillchars = {
    vert = "│",
    fold = " ",
    eob = " ",
}

--------------------------------------------------
-- SMALL, USEFUL KEYBINDS
--------------------------------------------------

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Easier terminal escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

--------------------------------------------------
-- TREESITTER
--------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "bash",
        "json",
        "lua",
        "nix",
        "python",
        "rust",
        "toml",
    },

    callback = function()
        pcall(vim.treesitter.start)
    end,
})

--------------------------------------------------
-- TELESCOPE
--------------------------------------------------

local telescope = require("telescope")

telescope.setup({
    defaults = {
        layout_strategy = "horizontal",

        layout_config = {
            horizontal = {
                preview_width = 0.55,
            },
        },

        sorting_strategy = "ascending",
        prompt_prefix = "   ",
        selection_caret = "❯ ",
    },
})

local builtin = require("telescope.builtin")

vim.keymap.set(
    "n",
    "<leader>ff",
    builtin.find_files,
    { desc = "Find files" }
)

vim.keymap.set(
    "n",
    "<leader>fg",
    builtin.live_grep,
    { desc = "Search text" }
)

--------------------------------------------------
-- LSP
--------------------------------------------------

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
})

vim.lsp.enable({
    "rust_analyzer",
    "pyright",
    "ruff",
    "nixd",
    "lua_ls",
    "taplo",
})

--------------------------------------------------
-- LSP COMPLETION
--------------------------------------------------

vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
    "popup",
}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my-lsp-completion", {
        clear = true,
    }),

    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if not client then
            return
        end

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(
                true,
                client.id,
                event.buf,
                {
                    autotrigger = true,
                }
            )
        end
    end,
})

-- Manually request completion
vim.keymap.set("i", "<C-Space>", function()
    vim.lsp.completion.get()
end, {
    desc = "Trigger completion",
})

--------------------------------------------------
-- GIT SIGNS
--------------------------------------------------

local gitsigns = require("gitsigns")

gitsigns.setup({
    signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "│" },
        untracked    = { text = "┆" },
    },

    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,

    current_line_blame = false,

    on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
                buffer = bufnr,
                desc = desc,
            })
        end

        -- Navigate Git hunks
        map("n", "]c", function()
            gitsigns.nav_hunk("next")
        end, "Next Git hunk")

        map("n", "[c", function()
            gitsigns.nav_hunk("prev")
        end, "Previous Git hunk")

        -- Preview current change
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")

        -- Stage / reset current hunk
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")

        -- Undo previous hunk stage
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Undo staged hunk")

        -- Git blame current line
        map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
        end, "Blame current line")

        -- Diff current file against index
        map("n", "<leader>hd", gitsigns.diffthis, "Diff current file")
    end,
})

--------------------------------------------------
-- STATUS LINE
--------------------------------------------------

local custom_theme = {
    normal = {
        a = { fg = "#11111b", bg = "#89b4fa", gui = "bold" },
        b = { fg = "#cdd6f4", bg = "#313244" },
        c = { fg = "#cdd6f4", bg = "#181825" },
    },

    insert = {
        a = { fg = "#11111b", bg = "#a6e3a1", gui = "bold" },
    },

    visual = {
        a = { fg = "#11111b", bg = "#cba6f7", gui = "bold" },
    },

    replace = {
        a = { fg = "#11111b", bg = "#f38ba8", gui = "bold" },
    },

    command = {
        a = { fg = "#11111b", bg = "#f9e2af", gui = "bold" },
    },

    inactive = {
        a = { fg = "#7f849c", bg = "#181825" },
        b = { fg = "#7f849c", bg = "#181825" },
        c = { fg = "#7f849c", bg = "#181825" },
    },
}

require("lualine").setup({
    options = {
        theme = custom_theme,

        icons_enabled = true,

        component_separators = {
            left = "│",
            right = "│",
        },

        section_separators = {
            left = "",
            right = "",
        },

        globalstatus = true,
    },

    sections = {
        lualine_a = {
            "mode",
        },

        lualine_b = {
            "branch",
            "diff",
        },

        lualine_c = {
            {
                "filename",
                path = 1,
            },
        },

        lualine_x = {
            "diagnostics",
            "filetype",
        },

        lualine_y = {
            "progress",
        },

        lualine_z = {
            "location",
        },
    },
})

--------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------

vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    underline = true,

    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "󰌵",
        },
    },

    -- Keep the editor relatively quiet:
    -- only errors and warnings appear inline.
    virtual_text = {
        spacing = 2,
        source = "if_many",
        severity = {
            min = vim.diagnostic.severity.WARN,
        },
    },

    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

--------------------------------------------------
-- FORMATTING
--------------------------------------------------

local formatter_for_filetype = {
    rust = "rust_analyzer",
    python = "ruff",
    toml = "taplo",
}

local function format_buffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local filetype = vim.bo[bufnr].filetype
    local formatter = formatter_for_filetype[filetype]

    if not formatter then
        return
    end

    vim.lsp.buf.format({
        bufnr = bufnr,
        name = formatter,
        async = false,
        timeout_ms = 3000,
    })
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup(
        "lsp-format-on-save",
        { clear = true }
    ),

    pattern = {
        "*.rs",
        "*.py",
        "*.toml",
    },

    callback = function(args)
        format_buffer(args.buf)
    end,
})

vim.keymap.set(
    "n",
    "<leader>cf",
    function()
        format_buffer()
    end,
    {
        desc = "Format code",
    }
)


--------------------------------------------------
-- BUFFER LINE
--------------------------------------------------

require("bufferline").setup({
    options = {
        mode = "buffers",

        numbers = "none",

        diagnostics = "nvim_lsp",

        separator_style = "thin",

        always_show_bufferline = true,

        show_buffer_close_icons = true,
        show_close_icon = false,

        offsets = {},

        indicator = {
            style = "underline",
        },
    },
})

vim.keymap.set(
    "n",
    "<Tab>",
    "<cmd>BufferLineCycleNext<CR>",
    { desc = "Next buffer" }
)

vim.keymap.set(
    "n",
    "<S-Tab>",
    "<cmd>BufferLineCyclePrev<CR>",
    { desc = "Previous buffer" }
)

vim.keymap.set(
    "n",
    "<leader>bd",
    "<cmd>bdelete<CR>",
    { desc = "Delete buffer" }
)

--------------------------------------------------
-- INDENT GUIDES
--------------------------------------------------

require("ibl").setup({
    indent = {
        char = "│",
    },

    scope = {
        enabled = true,
        show_start = false,
        show_end = false,
    },

    exclude = {
        filetypes = {
            "help",
            "terminal",
            "TelescopePrompt",
            "lazy",
        },
    },
})

--------------------------------------------------
-- WHICH KEY
--------------------------------------------------

local wk = require("which-key")

wk.setup({
    preset = "modern",

    delay = 300,

    icons = {
        mappings = true,
    },

    win = {
        border = "rounded",
    },
})

wk.add({
    { "<leader>f", group = "Find" },
    { "<leader>h", group = "Git hunks" },
    { "<leader>b", group = "Buffers" },
    { "<leader>c", group = "Code" },
})

vim.keymap.set("n", "<leader>?", function()
    wk.show({ global = false })
end, {
    desc = "Show buffer keymaps",
})


