-- Set wildignore patterns
vim.opt.wildignore:append("*/vendor/rails/*")
vim.opt.wildignore:append("*/tmp/*")
vim.opt.wildignore:append("*/.git/*")
vim.opt.wildignore:append("*/log/*")
vim.opt.wildignore:append("*/images/*")
vim.opt.wildignore:append("*/fonts/*")
vim.opt.wildignore:append("*/vendor/*")
vim.opt.wildignore:append("*/node_modules/*")
vim.opt.wildignore:append("*/bower_components/*")
vim.opt.wildignore:append("*/spec/reports/*")
vim.opt.wildignore:append("*/spec/vcr_cassettes/*")

-- Disable mouse support
vim.opt.mouse = ""

vim.opt.switchbuf = "useopen,usetab"

local function wildignore_from_gitignore()
  -- Find the root directory of the git repository
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if not git_root or git_root == '' then
    print('Unable to find git root')
    return
  end

  -- Construct the path to the .gitignore file
  local gitignore = git_root .. '/.gitignore'

  -- Check if the .gitignore file exists
  if not vim.loop.fs_stat(gitignore) then
    print('Unable to find .gitignore')
    return
  end

  -- Read the .gitignore file
  local lines = vim.fn.readfile(gitignore)
  if not lines then
    print('Failed to read .gitignore')
    return
  end

  -- Process each line of the .gitignore file
  local igstring = ''
  for _, oline in ipairs(lines) do
    local line = oline:gsub('%s+', '')
    if line:match('^#') or line == '' or line:match('^!') then
      goto continue
    end
    if line:match('/$') then
      igstring = igstring .. ',' .. line .. '*'
    else
      igstring = igstring .. ',' .. line
    end
    ::continue::
  end

  -- Set the wildignore option
  if igstring ~= '' then
    vim.opt.wildignore:append(',' .. igstring:sub(2))
    print('Wildignore defined from .gitignore in: ' .. git_root)
  else
    print('No valid patterns found in .gitignore')
  end
end

vim.g.ruby_host_prog = "~/.config/nvim/neovim-ruby-host-wrapper"

-- Basic Setup
vim.opt.number = true              -- Show line numbers
vim.opt.ruler = true               -- Show line and column number
vim.cmd("syntax enable")           -- Turn on syntax highlighting

-- Neovim disallow changing 'encoding' option after initialization
if not vim.fn.has('nvim') then
  vim.opt.encoding = 'utf-8'       -- Set default encoding to UTF-8
end

-- Whitespace
vim.opt.wrap = false               -- Don't wrap lines
vim.opt.tabstop = 2                -- A tab is two spaces
vim.opt.shiftwidth = 2             -- An autoindent (with <<) is two spaces
vim.opt.expandtab = true           -- Use spaces, not tabs
vim.opt.list = true                -- Show invisible characters
vim.opt.backspace = 'indent,eol,start'  -- Backspace through everything in insert mode

if vim.g.enable_mvim_shift_arrow then
  vim.g.macvim_hig_shift_movement = 1  -- mvim shift-arrow-keys
end

-- List chars
vim.opt.listchars = {
  tab = '  ',                      -- A tab should display as "  "
  trail = '.',                     -- Show trailing spaces as dots
  extends = '>',                   -- Character to show in the last column when wrap is off
  precedes = '<',                  -- Character to show in the last column when wrap is off
}

-- Searching
vim.opt.hlsearch = true            -- Highlight matches
vim.opt.incsearch = true           -- Incremental searching
vim.opt.ignorecase = true          -- Searches are case insensitive...
vim.opt.smartcase = true           -- ... unless they contain at least one capital letter

-- Wild settings
vim.opt.wildignore:append{
  '*.o', '*.out', '*.obj', '.git', '*.rbc', '*.rbo', '*.class', '.svn', '*.gem', -- Output and VCS files
  '*.zip', '*.tar.gz', '*.tar.bz2', '*.rar', '*.tar.xz', -- Archive files
  '*/vendor/gems/*', '*/vendor/cache/*', '*/.bundle/*', '*/.sass-cache/*', -- Bundler and sass cache
  '*/tmp/librarian/*', '*/.vagrant/*', '*/.kitchen/*', '*/vendor/cookbooks/*', -- Librarian-chef, vagrant, test-kitchen and Berkshelf cache
  '*/tmp/cache/assets/*/sprockets/*', '*/tmp/cache/assets/*/sass/*', -- Rails temporary asset caches
  '*.swp', '*~', '._*', -- Temp and backup files
}

-- Backup and swap files
vim.opt.backupdir:append('~/.vim/_backup//')    -- Where to put backup files
vim.opt.directory:append('~/.vim/_temp//')      -- Where to put swap files

-- Create an autocommand group for better management
vim.api.nvim_create_augroup('RestoreCursorGroup', { clear = true })

-- Define the autocommand
vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'RestoreCursorGroup',
  pattern = '*',
  callback = function()
    -- Check the file type and line conditions
    if vim.bo.filetype:match('^git') == nil and vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line('$') then
      vim.cmd("normal! g`\"")
    end
  end,
})

-- General Mappings (Normal, Visual, Operator-pending)
local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- Toggle paste mode
map('n', '<F4>', ':set invpaste<CR>:set paste?<CR>', { silent = true })
map('i', '<F4>', '<ESC>:set invpaste<CR>:set paste?<CR>', { silent = true })

-- Format the entire file
map('n', '<leader>fef', ':normal! gg=G``<CR>', default_opts)

-- Upper/lower word
map('n', '<leader>u', 'mQviwU`Q', default_opts)
map('n', '<leader>l', 'mQviwu`Q', default_opts)

-- Upper/lower first char of word
map('n', '<leader>U', 'mQgewvU`Q', default_opts)
map('n', '<leader>L', 'mQgewvu`Q', default_opts)

-- Change directory to the directory containing the file in the buffer
map('n', '<leader>cd', ':lcd %:h<CR>', default_opts)

-- Create the directory containing the file in the buffer
map('n', '<leader>md', ':!mkdir -p %:p:h<CR>', default_opts)

-- Edit mode helpers
map('n', '<leader>ew', ':e <C-R>=expand("%:h")."/"<CR>', default_opts)
map('n', '<leader>es', ':sp <C-R>=expand("%:h")."/"<CR>', default_opts)
map('n', '<leader>ev', ':vsp <C-R>=expand("%:h")."/"<CR>', default_opts)
map('n', '<leader>et', ':tabe <C-R>=expand("%:h")."/"<CR>', default_opts)

-- Swap two words
map('n', 'gw', ':s/\\(\\%#\\w\\+\\)\\(_W\\+\\)\\(\\w\\+\\)/\\3\\2\\1/<CR>`\'', { silent = true })

-- Underline the current line with '='
map('n', '<leader>ul', ':t.<CR>Vr=', { silent = true })

-- Toggle text wrapping
map('n', '<leader>tw', ':set invwrap<CR>:set wrap?<CR>', { silent = true })

-- Find merge conflict markers
map('n', '<leader>fc', '<ESC>/\\v^[<=>]{7}( .*\\|$)<CR>', { silent = true })

-- Map the arrow keys to be based on display lines, not physical lines
map('', '<Down>', 'gj', default_opts)
map('', '<Up>', 'gk', default_opts)

-- Toggle hlsearch
map('n', '<leader>hs', ':set hlsearch! hlsearch?<CR>', { silent = true })

-- Adjust viewports to the same size
map('', '<leader>=', '<C-w>=', default_opts)

-- Conditional mappings for GUI MacVim and other GUI Vim versions
if vim.fn.has("gui_macvim") == 1 and vim.fn.has("gui_running") == 1 then
  -- MacVim specific mappings
  map('v', '<D-]>', '>gv', default_opts)
  map('v', '<D-[>', '<gv', default_opts)
  map('n', '<D-]>', '>>', default_opts)
  map('n', '<D-[>', '<<', default_opts)
  map('o', '<D-]>', '>>', default_opts)
  map('o', '<D-[>', '<<', default_opts)
  map('i', '<D-]>', '<Esc>>>i', default_opts)
  map('i', '<D-[>', '<Esc><<i', default_opts)

  -- Bubble single lines
  map('n', '<D-Up>', '[e', { silent = true })
  map('n', '<D-Down>', ']e', { silent = true })
  map('n', '<D-k>', '[e', { silent = true })
  map('n', '<D-j>', ']e', { silent = true })

  -- Bubble multiple lines
  map('v', '<D-Up>', '[egv', { silent = true })
  map('v', '<D-Down>', ']egv', { silent = true })
  map('v', '<D-k>', '[egv', { silent = true })
  map('v', '<D-j>', ']egv', { silent = true })

  -- Map Command-# to switch tabs
  for i = 0, 9 do
    map('', '<D-' .. i .. '>', i .. 'gt', default_opts)
    map('i', '<D-' .. i .. '>', '<Esc>' .. i .. 'gt', default_opts)
  end
else
  -- Other GUI specific mappings
  map('v', '<A-]>', '>gv', default_opts)
  map('v', '<A-[>', '<gv', default_opts)
  map('n', '<A-]>', '>>', default_opts)
  map('n', '<A-[>', '<<', default_opts)
  map('o', '<A-]>', '>>', default_opts)
  map('o', '<A-[>', '<<', default_opts)
  map('i', '<A-]>', '<Esc>>>i', default_opts)
  map('i', '<A-[>', '<Esc><<i', default_opts)

  -- Bubble single lines
  map('n', '<C-Up>', '[e', { silent = true })
  map('n', '<C-Down>', ']e', { silent = true })
  map('n', '<C-k>', '[e', { silent = true })
  map('n', '<C-j>', ']e', { silent = true })

  -- Bubble multiple lines
  map('v', '<C-Up>', '[egv', { silent = true })
  map('v', '<C-Down>', ']egv', { silent = true })
  map('v', '<C-k>', '[egv', { silent = true })
  map('v', '<C-j>', ']egv', { silent = true })

  -- Make shift-insert work like in Xterm
  map('', '<S-Insert>', '<MiddleMouse>', default_opts)
  map('i', '<S-Insert>', '<MiddleMouse>', default_opts)

  -- Map Control-# to switch tabs
  for i = 0, 9 do
    map('', '<C-' .. i .. '>', i .. 'gt', default_opts)
    map('i', '<C-' .. i .. '>', '<Esc>' .. i .. 'gt', default_opts)
  end
end

-- Command-Line Mappings
vim.api.nvim_set_keymap('c', '<C-P>', [[getcmdline()[getcmdpos()-2] ==# ' ' ? expand('%:p:h') : "\<C-P>"]], { expr = true, noremap = true })

require("config.lazy")

-- Set colorscheme and terminal colors
vim.opt.termguicolors = true
vim.opt.colorcolumn = "120"

-- Modify mouse setting
vim.opt.mouse:remove("a")

-- Define augroup for cleanup
vim.cmd([[
augroup cleanup
  autocmd!
  autocmd FileType c,cpp,java,php,ruby,markdown,yaml,javascript,haml,coffee,lua autocmd BufWritePre <buffer> %s/\s\+$//e
  autocmd FileType c,cpp,java,php,ruby,markdown,yaml,javascript,haml,coffee,lua autocmd BufWritePre <buffer> retab
augroup END
]])

-- Define augroup for php settings
vim.cmd([[
augroup php
  autocmd!
  autocmd FileType php set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType lua set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END
]])

-- Set syntax for specific file type
vim.cmd([[
  autocmd BufNewFile,BufRead *.jb set syntax=ruby
]])

wildignore_from_gitignore()
