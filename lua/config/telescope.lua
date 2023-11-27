local M = {}

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require('telescope.builtin').live_grep({
			search_dirs = { git_root },
		})
	end
end
function M.setup()
	local actions = require('telescope.actions')
	local project_actions = require("telescope._extensions.project.actions")
	require('telescope').setup {
		extensions = {
			project = {
				hidden_files = true, -- default: false
				theme = "dropdown",
				order_by = "asc",
				search_by = "title",
				sync_with_nvim_tree = true, -- default false
				-- default for on_project_selected = find project files
				on_project_selected = function(prompt_bufnr)
					project_actions.change_working_directory(prompt_bufnr, false)
				end
			}
		},
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,

					['<C-u>'] = false,
					['<C-d>'] = false,
				},
			},
		},
	}
	-- Enable telescope fzf native, if installed
	pcall(require('telescope').load_extension, 'fzf')
	vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
	pcall(require('telescope').load_extension, 'project')
end

return M
