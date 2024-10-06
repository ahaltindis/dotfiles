--
-- PLUGINS
--
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "sainnhe/gruvbox-material",
      config = function()
        vim.cmd.colorscheme("gruvbox-material")
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require('nvim-treesitter.configs').setup({
          -- A list of parser names, or "all" (the listed parsers MUST always be installed)
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python" },

          auto_install = true,

          highlight = {
            enabled = true,

            -- Disable slow treesitter highlight for large files
            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<Leader>ss",
              node_incremental = "<Leader>si",
              scope_incremental = "<Leader>sc",
              node_decremental = "<Leader>sd",
            },
          },

          textobjects = {
            select = {
              enable = true,

              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,

              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              },
              selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'v',  -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
              },
              include_surrounding_whitespace = true,
            },
          },

        })
      end,
    },
    -- installs the textobjects part of the treesitter
    {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",           -- installs the actual lsps that nvim-lspconfig can use
        "williamboman/mason-lspconfig.nvim", -- bridge between mason and lspconfigs
        "hrsh7th/cmp-nvim-lsp",              -- extra client capabilities
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp", -- autocompletion
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind-nvim", -- emojis in the completion menu for function/package etc.
        -- "j-hui/fidget.nvim",  -- notifications as widget
      },
      config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require("mason").setup()
        require("mason-lspconfig").setup()
        require("mason-lspconfig").setup_handlers({
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities
            })
          end,
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = "Lua 5.1" },
                  diagnostics = {
                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                  }
                }
              }
            }
          end,
        })

        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
          },
          formatting = {
            format = lspkind.cmp_format {
              with_text = true,
              menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
              },
            },
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                if #cmp.get_entries() == 1 then
                  cmp.confirm({ select = true })
                else
                  cmp.select_next_item()
                end
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
                if #cmp.get_entries() == 1 then
                  cmp.confirm({ select = true })
                end
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),
          preselect = cmp.PreselectMode.None,
          window = {
            documentation = cmp.config.window.bordered(),
          },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip', keyword_length = 2 },
          }, {
            { name = 'buffer', keyword_length = 5 },
          })
        })
      end
    },
    {
      'akinsho/bufferline.nvim',
      version = "*",
      dependencies = 'nvim-tree/nvim-web-devicons',
      config = function()
        require("bufferline").setup({
          options = {
            numbers = "none",
            diagnostics = "nvim_lsp",
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true,
              }
            },
            show_buffer_icons = true,
            separator_style = "slant",
            hover = {
              enabled = true,
              delay = 200,
              reveal = { 'close' }
            },
            sort_by = "directory"
          },
        })
      end
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup()
      end
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require("nvim-tree").setup({
          sort = {
            sorter = "case_sensitive",
          },
          view = {
            width = 40,
          },
          renderer = {
            group_empty = true,
            highlight_git = true,
            highlight_opened_files = "all",
          },
          filters = {
            dotfiles = true,
          },
          on_attach = function(bufnr)
            local api = require "nvim-tree.api"

            local function opts(desc)
              return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            --
            vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
            vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
          end
        })

        -- Make :bd and :q behave as usual when tree is visible
        vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
          nested = false,
          callback = function(e)
            local tree = require('nvim-tree.api').tree

            -- Nothing to do if tree is not opened
            if not tree.is_visible() then
              return
            end

            -- How many focusable windows do we have? (excluding e.g. incline status window)
            local winCount = 0
            for _,winId in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_config(winId).focusable then
                winCount = winCount + 1
              end
            end

            -- We want to quit and only one window besides tree is left
            if e.event == 'QuitPre' and winCount == 2 then
              vim.api.nvim_cmd({cmd = 'qall'}, {})
            end

            -- :bd was probably issued an only tree window is left
            -- Behave as if tree was closed (see `:h :bd`)
            if e.event == 'BufEnter' and winCount == 1 then
              -- Required to avoid "Vim:E444: Cannot close last window"
              vim.defer_fn(function()
                -- close nvim-tree: will go to the last buffer used before closing
                tree.toggle({find_file = true, focus = true})
                -- re-open nivm-tree
                tree.toggle({find_file = true, focus = false})
              end, 10)
            end
          end
        })
      end
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
      },
      config = function()
        require("telescope").setup({
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
            }
          }
        })
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function() 
        require('gitsigns').setup{
          on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
              else
                gitsigns.nav_hunk('next')
              end
            end)

            map('n', '[c', function()
              if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
              else
                gitsigns.nav_hunk('prev')
              end
            end)

            -- Actions
            map('n', '<leader>hs', gitsigns.stage_hunk)
            map('n', '<leader>hr', gitsigns.reset_hunk)
            map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('n', '<leader>hS', gitsigns.stage_buffer)
            map('n', '<leader>hu', gitsigns.undo_stage_hunk)
            map('n', '<leader>hR', gitsigns.reset_buffer)
            map('n', '<leader>hp', gitsigns.preview_hunk)
            map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
            map('n', '<leader>hd', gitsigns.diffthis)
            map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
            map('n', '<leader>td', gitsigns.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end
        }
      end
    },
    {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup({})
      end
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("ibl").setup({
          indent = { 
            highlight = {
              "Whitespace",
            }, 
            char = ".",
          },
          scope = { 
            enabled = false
          },
        })
      end
    },
    -- save last cursor position
    {
      "ethanholz/nvim-lastplace",
      config = function()
        require("nvim-lastplace").setup({
          lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
          lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
          lastplace_open_folds = true
        })
      end,
    },
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    {
      "smjonas/inc-rename.nvim",
      config = function()
        require("inc_rename").setup()
      end,
    },
    {
      "voldikss/vim-floaterm",
    }
  }
})

--
-- OPTIONS
--
vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true -- copy indent from current line when starting a new line

-- plus is the register that connected to the system clipboard
vim.opt.clipboard = "unnamedplus"

-- start scrolling in the mid screen
vim.opt.scrolloff = 999

-- free form movement in the visual block mode
vim.opt.virtualedit = "block"

-- show preview in split window (e.g. search and replace :%s/foo/bar)
vim.opt.inccommand = "split"

-- ignore case when searching for a command and autocomplete
vim.opt.ignorecase = true

-- ignore default terminal colors and allow to use rich colors
vim.opt.termguicolors = true

-- time it takes to trigger the `CursorHold` event (e.g. highlight symbol)
vim.opt.updatetime = 400

-- disable default filebrowser netrw because using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set leader to empty space
vim.g.mapleader = " "

-- Move selected lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor at the same line when joining below lines
vim.keymap.set('n', 'J', "mzJ`z")

-- When sth pasted on a selected text, don't change the clipboard with the deleted chunk
vim.keymap.set('x', "p", "\"_dP")

-- window switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- buffers
vim.keymap.set("n", "<C-n>", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<C-m>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>") -- other buffer
vim.keymap.set("n", "<leader>bd", "<cmd>:bd<cr>")
vim.keymap.set("n", "<leader>bD", "<cmd>:bd!<cr>")

-- Don't jump forward if I higlight and search for a word
local function stay_star()
  local sview = vim.fn.winsaveview()
  local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
  vim.api.nvim_command(args)
  vim.fn.winrestview(sview)
end
vim.keymap.set('n', '*', stay_star, { noremap = true, silent = true })

-- Remove search highlight
vim.keymap.set('n', '<Leader><space>', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })

-- File-tree mappings
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<leader>m', ':NvimTreeFindFile!<CR>', { noremap = true })

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>ds', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>gs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>gg', builtin.live_grep, {})

-- diagnostics
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.diagnostic.config({
  virtual_text = false,  -- bloating the view a lot so hide diagnostic texts. Just symbols are enough.
})

--lsp
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', ':IncRename', opts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

    local function highlight_symbol(event)
      local id = vim.tbl_get(event, 'data', 'client_id')
      local client = id and vim.lsp.get_client_by_id(id)
      if client == nil or not client.supports_method('textDocument/documentHighlight') then
        return
      end

      local group = vim.api.nvim_create_augroup('highlight_symbol', {clear = false})

      vim.api.nvim_clear_autocmds({buffer = event.buf, group = group})

      vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = group,
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
        group = group,
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    highlight_symbol(event)
  end
})

-- lazygit
vim.keymap.set('n', '<leader>l', "<cmd>LazyGit<cr>")

-- floaterm
vim.keymap.set("n", "<leader>o", ":FloatermToggle<CR>")
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:FloatermToggle<CR>")
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>:FloatermNew<CR>")
vim.keymap.set("t", "<C-i>", "<C-\\><C-n>:FloatermPrev<CR>")
vim.keymap.set("t", "<C-p>", "<C-\\><C-n>:FloatermNext<CR>")
-- Close terminal window, even if we are in insert mode
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:q<cr>')
-- Switch to normal mode with esc
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
-- Something hijacking Tab in terminal mode, so let Tab autocomplete in terminal mode as usual.
vim.keymap.del("t", "<Tab>")

