return {
  {
    "rktjmp/lush.nvim",
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- build = "npm install -g mcp-hub@latest",
    build = "bundled_build.lua",
    config = function()
      require("mcphub").setup({
        -- port = 5999,
        config = vim.fn.expand("~/.config/nvim/nvim-mcp-servers.json"),
        use_bundled_binary = true,
        extensions = {
          codecompanion = {
            show_result_in_chat = true,
            make_vars = true,
            make_slash_commands = true,
          }
        }
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "javascript", "typescript", "elixir", "ruby" },
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = {
              enable = true,
            },
          })
        end,
      },
      { "nvim-lua/plenary.nvim" },
      {
        "saghen/blink.cmp",
        lazy = false,
        version = "*",
        opts = {
          keymap = {
            preset = "enter",
            ["<Tab>"] = {},
            -- ["<S-Tab>"] = { "select_prev", "fallback" },
            -- ["<Tab>"] = { "select_next", "fallback" },
            ["<C-space>"] = { "show", "fallback" },
          },
          completion = {
            list = {
              selection = {
                preselect = false
              }
            }
          },
          cmdline = { sources = { "cmdline" } },
          sources = {
            per_filetype = {
              codecompanion = { "codecompanion" },
            },
            default = { "lsp", "buffer", "snippets", "path", "omni", "codecompanion" },
          }
        }
      }
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          tools = {
            ["mcp"] = {
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                requires_approval = true,
              }
            }
          }
        },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      opts = {
        log_level = "DEBUG",
      }
    },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = 1
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = true,
        theme = "wave", -- alternatives: dragon, lotus
      })
--      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({
        options = { transparent = true }
      })
--      vim.cmd("colorscheme terafox") -- or carbonfox
    end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = true
      vim.g.everforest_transparent_background = 1
--      vim.cmd("colorscheme everforest")
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    lazy = false,
    dependencies = {
      "rktjmp/lush.nvim",
    },
    priority = 1000,
    config = function()
--      vim.cmd([[colorscheme zenburned]])
--      vim.api.nvim_set_hl(0, "Normal", { bg = "black" })
--      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
  {
    "ViViDboarder/wombat.nvim",
    lazy = false,
    priority = 1000,
    config = function()
--      vim.cmd([[colorscheme wombat_lush]])
    end,
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
  {
    "wincent/command-t",
    lazy = false,
    -- build = "cd lua/wincent/commandt/lib && make",
    build = "cd ruby/command-t/ext/command-t && make clean && /usr/local/opt/ruby/bin/ruby extconf.rb && make",
    init = function()
      vim.g.CommandTPreferredImplementation = 'ruby'
      vim.api.nvim_set_keymap('n', '<C-p>', ':CommandT<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>b', ':CommandTBuffer<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>j', ':CommandTJump<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>o', ':CommandTOpen<CR>', { noremap = true, silent = true })
    end,
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "tpope/vim-unimpaired",
  },
  {
    "github/copilot.vim",
    init = function()
      vim.g.copilot_workspace_folders = { '~/work' }
      vim.api.nvim_set_keymap('i', '<C-k>', '<ESC>:Copilot panel<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-k>', ':Copilot panel<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('i', '<C-n>', '<Plug>(copilot-next)', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('i', '<C-p>', '<Plug>(copilot-previous)', { noremap = true, silent = true })
    end,
  },
  {
    "ap/vim-css-color",
  },
  {
    "bronson/vim-trailing-whitespace",
  },
  {
    "sheerun/vim-polyglot",
  },
  {
    "sbdchd/neoformat",
    init = function()
      vim.g.neoformat_enabled_javascript = { "prettier" }
      vim.g.neoformat_enabled_typescript = { "prettier" }
      vim.g.neoformat_enabled_typescriptreact = { "prettier" }
      vim.g.neoformat_enabled_javascriptreact = { "prettier" }
      vim.g.neoformat_enabled_ruby = { "rubocop" }
      vim.g.neoformat_enabled_elixir = { "mix_format" }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
     lazy = false,
     init = function()
       require('gitsigns').setup {
         numhl = true,
         word_diff = false,
         current_line_blame = true,
         signs = {
           add = { text = "+" },
           change = { text = "~" },
         },
         signs_staged = {
           add = { text = "+" },
           change = { text = "~" },
         },
       }
     end,
  },
  {
    "preservim/nerdtree",
    init = function()
      vim.g.NERDTreeHijackNetrw = 0
    end,
    config = function()
      vim.g.NERDTreeIgnore = {'\\.pyc$', '\\.pyo$', '\\.rbc$', '\\.rbo$', '\\.class$', '\\.o$', '\\~$'}
      vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>:NERDTreeMirror<CR>', { noremap = true, silent = true })

      local function CdIfDirectory(directory)
        local explicitDirectory = vim.fn.isdirectory(directory) == 1
        local isDirectory = explicitDirectory or directory == ""

        if explicitDirectory then
          vim.cmd("cd " .. vim.fn.fnameescape(directory))
        end

        if directory == "" then
          return
        end

        if isDirectory then
          vim.cmd("NERDTree")
          vim.cmd("wincmd p")
          vim.cmd("bd")
        end

        if explicitDirectory then
          vim.cmd("wincmd p")
        end
      end

      local function UpdateNERDTree(stay)
        stay = stay or 0

        if vim.t.NERDTreeBufName then
          local nr = vim.fn.bufwinnr(vim.t.NERDTreeBufName)
          if nr ~= -1 then
            vim.cmd(nr .. "wincmd w")
            local map_check = vim.fn.mapcheck("R")
            local keymap = string.gsub(map_check, "<CR>", "")
            vim.cmd(keymap)
            if stay == 0 then
              vim.cmd("wincmd p")
            end
          end
        end
      end

      -- Create autocommands
      vim.api.nvim_create_augroup("AuNERDTreeCmd", { clear = true })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = "AuNERDTreeCmd",
        pattern = "*",
        callback = function() CdIfDirectory(vim.fn.expand("<amatch>")) end
      })
      vim.api.nvim_create_autocmd("FocusGained", {
        group = "AuNERDTreeCmd",
        pattern = "*",
        callback = function() UpdateNERDTree() end
      })
    end,
  },
  {
    "dense-analysis/ale",
    init = function()
      local g = vim.g
      g.ale_linters = {
        ruby = {"rubocop", "ruby"},
        javascript = {"eslint"},
        typescript = {"eslint"},
        typescriptreact = {"eslint"},
        javascriptreact = {"eslint"},
        elixir = {"credo"},
      }
      g.ale_use_neovim_diagnostics_api = 1
      g.ale_linters_explicit = 1
      g.ale_sign_column_always = 1
      g.ale_set_highlights = 1
    end,
  },
  {
    "vim-airline/vim-airline",
    init = function()
      vim.g['airline#extensions#ale#enabled'] = 1
    end,
  },
  {
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "ag --vimgrep"
    end
  },
}
