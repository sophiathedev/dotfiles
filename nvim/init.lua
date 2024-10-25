local function t(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = t'<Space>'

vim.fn['plug#begin']()

-- Navigation plugins
vim.cmd [[Plug 'rbgrouleff/bclose.vim']]
vim.cmd [[Plug 'nvim-tree/nvim-tree.lua']]
vim.cmd [[Plug 'nvim-tree/nvim-web-devicons']]
vim.cmd [[Plug 'nvim-lua/plenary.nvim']]

-- UI Plugins
vim.cmd [[Plug 'vim-airline/vim-airline']]
vim.cmd [[Plug 'vim-airline/vim-airline-themes']]

-- Editor plugins
vim.cmd [[Plug 'airblade/vim-gitgutter']]
vim.cmd [[Plug 'windwp/nvim-autopairs']]
vim.cmd [[Plug 'ycm-core/YouCompleteMe']]

vim.cmd [[Plug 'maxmx03/solarized.nvim']]

vim.fn['plug#end']()

-- Setup for windwp
require('nvim-autopairs').setup({})
local npairs = require 'nvim-autopairs'
local Rule = require'nvim-autopairs.rule'
local cond = require 'nvim-autopairs.conds'

local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules {
  -- Rule for a pair with left-side ' ' and right side ' '
  Rule(' ', ' ')
    -- Pair will only occur if the conditional function returns true
    :with_pair(function(opts)
      -- We are checking if we are inserting a space in (), [], or {}
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2]
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        brackets[1][1] .. '  ' .. brackets[1][2],
        brackets[2][1] .. '  ' .. brackets[2][2],
        brackets[3][1] .. '  ' .. brackets[3][2]
      }, context)
    end)
}
-- For each pair of brackets we will add another rule
for _, bracket in pairs(brackets) do
  npairs.add_rules {
    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
    Rule(bracket[1] .. ' ', ' ' .. bracket[2])
      :with_pair(cond.none())
      :with_move(function(opts) return opts.char == bracket[2] end)
      :with_del(cond.none())
      :use_key(bracket[2])
      -- Removes the trailing whitespace that can occur without this
      :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
  }
end

vim.opt.backspace = { 'indent', 'eol', 'start' }
--vim.opt.softtabstop = 2
--vim.opt.shiftwidth = 2
--vim.opt.tabstop = 8
--vim.opt.expandtab = true

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = false

--vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.title = true
vim.opt.joinspaces = false
vim.opt.mouse = 'a'

vim.opt.conceallevel = 2

vim.opt.undofile = true

vim.opt.autoread = true
vim.cmd [[autocmd BufEnter,FocusGained * if mode() == 'n' && getcmdwintype() == '' | checktime | endif]]
vim.opt.updatetime = 50
vim.opt.splitright = true
vim.opt.splitbelow = true

-- searching options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- setup airline
vim.o.background = 'light'
vim.cmd [[colorscheme solarized]]
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#wordcount#enabled'] = 0
vim.g['airline#extensions#wordcount#filetypes'] = { 'help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail', 'pandoc' }

-- you completeme
vim.g['ycm_clangd_uses_ycmd_caching'] = 0
vim.cmd [[ set completeopt-=preview ]]

-- nvim tree
require("nvim-tree").setup({
	view = {
		width = 30,
	},
	filters = {
		dotfiles = true,
	},
})
vim.keymap.set("n", "<F8>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- split view
vim.keymap.set("n", "tl", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "th", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "tj", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "tk", "<C-w>k", { noremap = true, silent = true })

vim.cmd [[ highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000 ]]
vim.api.nvim_set_keymap('n', 'gA', ':%y+<CR>', { noremap = true })
