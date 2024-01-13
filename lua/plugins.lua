local M = {}
function M.setup()
	local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system {
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable', -- latest stable release
			lazypath,
		}
	end
	vim.opt.rtp:prepend(lazypath)

	require('lazy').setup({
		'tpope/vim-sleuth',
		{
			'neovim/nvim-lspconfig',
			dependencies = {
				'williamboman/mason.nvim',
				'williamboman/mason-lspconfig.nvim',
				{ 'j-hui/fidget.nvim', opts = {} },
				'folke/neodev.nvim',
			},
		},
		{
			-- Autocompletion
			'hrsh7th/nvim-cmp',
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',

				-- Adds LSP completion capabilities
				'hrsh7th/cmp-nvim-lsp',

				-- Adds a number of user-friendly snippets
				'rafamadriz/friendly-snippets',
			},
		},
		-- Useful plugin to show you pending keybinds.
		{ 'folke/which-key.nvim',  opts = {} },
		{
			-- Adds git related signs to the gutter, as well as utilities for managing changes
			'lewis6991/gitsigns.nvim',
			opts = {
				-- See `:help gitsigns.txt`
				signs = {
					add = { text = '+' },
					change = { text = '~' },
					delete = { text = '_' },
					topdelete = { text = '‾' },
					changedelete = { text = '~' },
				},
				on_attach = function(bufnr)
					vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
						{ buffer = bufnr, desc = 'Preview git hunk' })

					-- don't override the built-in and fugitive keymaps
					local gs = package.loaded.gitsigns
					vim.keymap.set({ 'n', 'v' }, ']c', function()
						if vim.wo.diff then
							return ']c'
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return '<Ignore>'
					end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
					vim.keymap.set({ 'n', 'v' }, '[c', function()
						if vim.wo.diff then
							return '[c'
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return '<Ignore>'
					end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
				end,
			},
		},
		{
			-- Theme inspired by Atom
			'navarasu/onedark.nvim',
			priority = 1000,
			config = function()
				vim.cmd.colorscheme 'onedark'
			end,
		},

		{
			-- Set lualine as statusline
			'nvim-lualine/lualine.nvim',
			-- See `:help lualine.txt`
			opts = {
				options = {
					icons_enabled = false,
					theme = 'onedark',
					component_separators = '|',
					section_separators = '',
				},
			},
		},

		-- {
		-- 	-- Add indentation guides even on blank lines
		-- 	'lukas-reineke/indent-blankline.nvim',
		-- 	-- Enable `lukas-reineke/indent-blankline.nvim`
		-- 	-- See `:help ibl`
		-- 	main = 'ibl',
		-- 	opts = {},
		-- },
		--
		{ 'numToStr/Comment.nvim', opts = {} },
		{
			'nvim-telescope/telescope.nvim',
			branch = '0.1.x',
			dependencies = {
				'nvim-lua/plenary.nvim',
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					build = 'make',
					cond = function()
						return vim.fn.executable 'make' == 1
					end,
				},
			},
		},
		{
			-- Highlight, edit, and navigate code
			'nvim-treesitter/nvim-treesitter',
			dependencies = {
				'nvim-treesitter/nvim-treesitter-textobjects',
			},
			build = ':TSUpdate',
		},
		{ 'nvim-tree/nvim-tree.lua',              dependencies = { 'navarasu/onedark.nvim' } },
		{ 'Shatur/neovim-tasks',                  config = true,                             dependencies = { 'nvim-lua/plenary.nvim' } },
		{ 'notjedi/nvim-rooter.lua' },
		{ 'nvim-telescope/telescope-project.nvim' },
		"Olical/conjure",
		{
			"ray-x/go.nvim",
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("go").setup()
			end,
			event = { "CmdlineEnter" },
			ft = { "go", 'gomod' },
			build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
		},
		{
			"ThePrimeagen/refactoring.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("refactoring").setup()
			end,
		},
		"ThePrimeagen/vim-be-good",
		"igankevich/mesonic"
	}, {})
	require("nvim-tree").setup({
		update_focused_file = {
			enable = true,
			update_cwd = false
		}
	})
	--require("nvim-rooter").setup({rooter_patterns = {'repman.yml','.git','.svn'}})
end

return M
