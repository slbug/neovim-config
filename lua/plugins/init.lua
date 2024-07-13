return {
  {
    "rktjmp/lush.nvim",
  },
  {
    "ViViDboarder/wombat.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme wombat_lush]])
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
    "github/copilot.vim",
  },
  {
    "ap/vim-css-color",
  },
  {
    "bronson/vim-trailing-whitespace",
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
