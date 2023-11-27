vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.python3_host_prog = '/home/matt/.pyenv/versions/neovim/bin/python'
require('opts').setup()
require('plugins').setup()
require('keys').setup()
require('config.telescope').setup()
require('config.lsp').setup()
require('config.treesitter').setup()
require('config.completions').setup()
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
