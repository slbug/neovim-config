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
        shutdown_delay = 0,
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
              disable = { "javascript", "typescript", "elixir", "ruby" },
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
      ignore_warnings = true,
      interactions = {
        chat = {
          adapter = "copilot",
          tools = {
            ["mcp"] = {
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                require_approval_before = true,
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
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_foreground = 'mix'
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.g.gruvbox_material_statusline_style = 'mix'
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
    build = "cd lua/wincent/commandt/lib && make",
    -- build = "cd ruby/command-t/ext/command-t && make clean && /usr/local/opt/ruby/bin/ruby extconf.rb && make",
    config = function()
        require('wincent.commandt').setup({
        })
    end,
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
    "neovim/nvim-lspconfig",
    config = function()
      -- Use solargraph for Ruby (better Rails support)
      vim.lsp.config.solargraph = {
        cmd = { vim.fn.expand("~/.config/nvim/solargraph-wrapper"), "stdio" },
        filetypes = { "ruby" },
        settings = {
          solargraph = {
            diagnostics = true,
            completion = true,
          }
        }
      }
      
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
      }
      
      vim.lsp.config.elixirls = {
        cmd = { "elixir-ls" },
        filetypes = { "elixir", "eelixir" },
      }

      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
          }
        }
      }

      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
      }

      -- Enable LSP servers
      vim.lsp.enable('solargraph')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('elixirls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('pyright')

      -- LSP keymaps (only when LSP is attached)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          ruby = { "rubocop" },
          elixir = { "mix" },
        },
      })
      
      -- Create :Format command (equivalent to :Neoformat)
      vim.api.nvim_create_user_command("Format", function(args)
        require("conform").format({ async = true, lsp_fallback = true })
      end, {})
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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
      vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle<cr>')
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
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
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox-material',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff'},
          lualine_c = {'filename'},
          lualine_x = {
            {
              'diagnostics',
              sources = { 'ale', 'nvim_lsp' },
              symbols = {error = ' ', warn = ' ', info = ' '},
            },
            'encoding',
            'fileformat',
            'filetype'
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },
  {
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "ag --vimgrep"
    end
  },
}
