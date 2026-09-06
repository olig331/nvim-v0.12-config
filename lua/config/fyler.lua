local M = {}

local function project_root(path)
	return vim.fs.root(path, { ".git" }) or path
end

function M.setup()
	require("fyler").setup({
		follow_current_file = false,
		follow_root_dir = false,
		hooks = {
			on_highlight = function(highlights)
				highlights.FylerNormal = { fg = "#dddddd" }
			end,
		},
		ui = {
			indent_guides = true,
		},
		mappings = {
			n = {
				["'"] = {
					action = function(finder)
						local root = project_root(finder.state.pseudo_root_path)
						if finder.state.pseudo_root_path ~= root then
							finder:visit({ parent = true })
						end
					end,
					desc = "Go to parent directory",
				},
				["<Tab>"] = {
					action = "visit",
					args = { cursor = true },
					desc = "Enter directory under cursor",
				},
				["<BS>"] = {
					action = "shrink",
					args = { parent = true },
					desc = "Collapse parent directory",
				},
				["<C-R>"] = {
					action = "refresh",
					args = { recursive = true, force = true },
					desc = "Force refresh tree",
				},
				["<C-S>"] = {
					action = function()
						vim.cmd.write()
					end,
					desc = "Write buffer",
				},
				["<C-h>"] = {
					action = function()
						vim.cmd.TmuxNavigateLeft()
					end,
					desc = "Navigate left",
				},
				["<C-l>"] = {
					action = function()
						vim.cmd.TmuxNavigateRight()
					end,
					desc = "Navigate right",
				},
				["<C-T>"] = {
					action = "select",
					args = { tabedit = true },
					desc = "Open in new tab",
				},
				["<C-V>"] = {
					action = "select",
					args = { vsplit = true },
					desc = "Open in vertical split",
				},
				["<CR>"] = {
					action = "select",
					args = { pick = true },
					desc = "Open with window picker",
				},
				["<2-LeftMouse>"] = {
					action = "select",
					args = { pick = true },
					desc = "Open with window picker",
				},
				["@"] = {
					action = function(finder)
						finder:visit({ path = project_root(finder.state.pseudo_root_path) })
					end,
					desc = "Go to project root",
				},
				["-"] = {
					action = function(finder)
						local root = project_root(finder.state.pseudo_root_path)
						if finder.state.pseudo_root_path ~= root then
							finder:visit({ parent = true })
						end
					end,
					desc = "Go to parent directory",
				},
				["g."] = {
					action = "toggle_ui",
					args = { "hidden_items" },
					desc = "Toggle hidden files",
				},
				["gi"] = {
					action = "toggle_ui",
					args = { "indent_guides" },
					desc = "Toggle indent guides",
				},
				["q"] = {
					action = "close",
					desc = "Close finder",
				},
			},
		},
	})
end

return M
