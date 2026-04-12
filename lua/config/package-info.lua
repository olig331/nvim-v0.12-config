local M = {}

function M.setup()
	require("package-info").setup({
		highlights = {
			up_to_date = { -- highlight for up to date dependency virtual text
				fg = "#8f8f8f",
			},
			outdated = { -- highlight for outdated dependency virtual text
				fg = "#F29C51",
			},
			invalid = { -- highlight for invalid dependency virtual text
				fg = "#e87487",
			},
		},
		icons = {
			enable = true, -- Whether to display icons
			style = {
				up_to_date = "| -", -- Icon for up to date dependencies
				outdated = "| ~", -- Icon for outdated dependencies
				invalid = "| !", -- Icon for invalid dependencies
			},
		},
		autostart = true,
		package_manager = "pnpm",
		hide_unstable_versions = true,
	})
end

return M
