local M = {}

function M.setup()
	--[[
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
--]]
	-- Remap for dealing with word wrap
	vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

	local nvimtree_api = require('nvim-tree.api')
	local wk = require("which-key")
	local top_level = {
		["<space>"] = { function() require('telescope.builtin').buffers({ sort_lastused = true, sort_mru = true }) end, '[ ] Find existing buffers' },
		["?"] = { require('telescope.builtin').oldfiles, '[?] Find recently opened files' },
		['.'] = { nvimtree_api.tree.toggle, 'NvimTree' },
		p = { require 'telescope'.extensions.project.project, 'Open project' }
	}
	local search_mapping = {
		s = {
			name = "Search",
			f = { require('telescope.builtin').find_files, '[S]earch [F]iles' },
			g = { require('telescope.builtin').live_grep, '[S]earch by [G]rep' },
			h = { require('telescope.builtin').help_tags, '[S]earch [H]elp' },
			w = { require('telescope.builtin').grep_string, '[S]earch current [W]ord' }
		}
	}
	wk.register(top_level, { prefix = "<leader>" })
	wk.register(search_mapping, { prefix = "<leader>" })
	--[[
	-- Keymaps for better default experience
	-- See `:help vim.keymap.set()`
	vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

	-- Remap for dealing with word wrap
	vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

	-- Diagnostic keymaps
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
	vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
	]]
	--
	vim.keymap.set('n', '<leader>/', function()
		-- You can pass additional configuration to telescope to change theme, layout, etc.
		require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			winblend = 10,
			previewer = false,
		})
	end, { desc = '[/] Fuzzily search in current buffer' })

	vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })


	-- document existing key chains
	require('which-key').register {
		['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
		['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
		--['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
		['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
		['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
		['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
	}
end

return M
