local M = {}
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	local wk = require("which-key")
	local goto_mapping = {
		g = {
			d = { require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition' },
			r = { require('telescope.builtin').lsp_references, '[G]oto [R]eferences'  },
			I = { require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation'},
			D = { vim.lsp.buf.declaration, '[G]oto [D]eclaration' },
			h = { "<Cmd>ClangdSwitchSourceHeader<Cr>", "[G]oto [H]header" }
		}
	}
	wk.register(goto_mapping, { buffer = bufnr })


	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

function M.setup()
	require('mason').setup()
	local mason_lspconfig = require('mason-lspconfig')
	mason_lspconfig.setup()
	local lspconfig_util = require('lspconfig.util')

	-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
	vim.lsp.set_log_level("debug")
	local servers = {
		clangd = {
			root_dir = function(fname)
				return lspconfig_util.root_pattern("compile_commands.json")(fname)
			end,
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "clangd", "--log=verbose", "--query-driver=/mnt/sw/nt/MDM5010SA/build/arm-cortexa9_5.4-linux-gnueabihf/bin/arm-cortexa9_5.4-linux-gnueabihf-gcc"}
		},
		lua_ls = {
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			capabilities = capabilities,
			on_attach = on_attach
		}
	}

	mason_lspconfig.setup {
		ensure_installed = vim.tbl_keys(servers),
	}
	-- nedev must get setup prior to lua language server
	require('neodev').setup()
	require('lspconfig').lua_ls.setup(servers['lua_ls'])
	require('lspconfig').clangd.setup(servers['clangd'])
	require('lspconfig').jsonls.setup { on_attach = on_attach }
end

return M
