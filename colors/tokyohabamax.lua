-- tokyohabamax: Custom color scheme based on habamax and tokyonight

vim.cmd.highlight("clear")
vim.g.colors_name = "tokyohabamax"
vim.o.termguicolors = true
vim.o.background = "dark"

-- Load habamax as the base
vim.cmd.runtime("colors/habamax.lua")
vim.g.colors_name = "tokyohabamax"

-- Palette (tokyonight-moon + custom overrides from colorscheme.lua)
local c = {
	bg = "#1f1f1f",
	bg_dark = "#1e2030",
	bg_darker = "#1b1d2b",
	bg_float = "#1a1a1a",
	bg_statusline = "#121212",
	bg_visual = "#595857",
	bg_cursorline = "#2f334d",
	bg_sel = "#2f334d",
	fg = "#c8d3f5",
	fg_bright = "#eeeeee",
	fg_muted = "#d4d4d8",
	fg_dim = "#8f8f8f",
	fg_gutter = "#3b4261",

	blue = "#96b5de",
	blue00 = "#c6dbf7",
	blue0 = "#7a9ec4",
	blue1 = "#96b5de",
	blue5 = "#88a4c4",
	blue6 = "#6a8eae",
	blue7 = "#5a7e9e",
	blue_muted = "#7f98bc",
	blue_mode = "#828bb8",
	cyan = "#96ccde",
	green = "#b4d49a",
	magenta = "#d6a6c8",
	orange = "#d6a488",
	purple = "#b6a0d6",
	red = "#d6949c",
	red_error = "#e87487",
	yellow = "#d6be98",
	teal = "#88c2b6",
	accent = "#F29C51",
	spell_undercurl = "#ff6b6b",

	-- diagnostic
	diag_error = "#e87487",
	diag_warn = "#ffc777",
	diag_info = "#0db9d7",
	diag_hint = "#4fd6be",

	-- statusline (from statusline.lua)
	sl_fg = "#dddddd",
	sl_fg_nc = "#888888",
	sl_error = "#f38ba8",
	sl_warn = "#f9e2af",
	sl_lsp_progress = "#89b4fa",
	sl_lsp_ready = "#a6e3a1",

	-- diff
	diff_add = "#2a4556",
	diff_change = "#252a3f",
	diff_delete = "#4b2a3d",
	diff_text = "#394b70",

	-- tab
	tab_fg = "#3b4261",
	tab_sel_fg = "#1b1d2b",
}

local hi = function(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalNC", { bg = c.bg })
hi("NormalFloat", { fg = c.fg_bright, bg = c.bg_float })
hi("FloatBorder", { fg = c.bg, bg = c.bg_float })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.bg_cursorline })
hi("CursorLineNr", { fg = "#dadada", bold = true })
hi("LineNr", { fg = c.fg_dim })
hi("LineNrAbove", { fg = c.fg_dim })
hi("LineNrBelow", { fg = c.fg_dim })
hi("SignColumn", { fg = c.fg_gutter, bg = c.bg })
hi("FoldColumn", { fg = "#636da6", bg = c.bg })
hi("Folded", { fg = c.blue, bg = c.fg_gutter })
hi("ColorColumn", { bg = "#3a3a3a" })
hi("Visual", { bg = c.bg_visual })
hi("VisualNOS", { bg = c.bg_visual })
hi("MatchParen", { fg = c.orange, bold = true })
hi("EndOfBuffer", { fg = c.bg })
hi("NonText", { fg = "#545c7e" })
hi("SpecialKey", { fg = "#545c7e" })
hi("Conceal", { fg = "#545c7e" })
hi("WinSeparator", { fg = c.bg_darker, bold = true })

-- Search
hi("Search", { fg = c.accent, bg = c.bg_visual })
hi("IncSearch", { fg = "#000000", bg = c.accent })
hi("CurSearch", { link = "IncSearch" })
hi("Substitute", { link = "Search" })

-- Pmenu
hi("Pmenu", { fg = c.fg_bright, bg = c.bg_float })
hi("PmenuSel", { fg = c.fg_bright, bg = c.bg_sel })
hi("PmenuSbar", { bg = c.bg_float })
hi("PmenuThumb", { bg = c.bg_visual })

-- Messages
hi("MsgArea", { fg = c.fg_bright, bg = c.bg_float })
hi("CmdLine", { fg = c.fg_bright, bg = c.bg_float })
hi("ErrorMsg", { fg = c.red_error })
hi("WarningMsg", { fg = c.diag_warn })
hi("MoreMsg", { fg = c.blue })
hi("ModeMsg", { fg = c.blue_mode, bold = true })
hi("Question", { fg = c.blue })
hi("Directory", { fg = c.blue })
hi("Title", { fg = c.blue, bold = true })

-- Tabs
hi("TabLine", { fg = c.tab_fg, bg = c.bg_dark })
hi("TabLineSel", { fg = c.tab_sel_fg, bg = c.blue })
hi("TabLineFill", { bg = c.bg_darker })

-- WildMenu
hi("WildMenu", { bg = "#2d3f76" })

-- Diff
hi("DiffAdd", { bg = c.diff_add })
hi("DiffChange", { bg = c.diff_change })
hi("DiffDelete", { fg = "#767676", bg = c.diff_delete })
hi("DiffText", { bg = c.diff_text })

-- Spell
hi("SpellBad", { undercurl = true, sp = c.spell_undercurl })
hi("SpellCap", { undercurl = true, sp = c.spell_undercurl })
hi("SpellLocal", { undercurl = true, sp = c.spell_undercurl })
hi("SpellRare", { undercurl = true, sp = c.spell_undercurl })

-- Diagnostics
hi("DiagnosticError", { fg = c.diag_error })
hi("DiagnosticWarn", { fg = c.diag_warn })
hi("DiagnosticInfo", { fg = c.diag_info })
hi("DiagnosticHint", { fg = c.diag_hint })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.diag_error })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.diag_warn })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.diag_info })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.diag_hint })

-- Syntax (tokyonight-moon palette)
hi("Comment", { fg = c.fg_dim, italic = false })
hi("Constant", { fg = c.orange })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.orange })
hi("Boolean", { fg = c.orange })
hi("Float", { fg = c.orange })
hi("Identifier", { fg = c.fg_muted })
hi("Function", { fg = c.blue })
hi("Statement", { fg = c.magenta })
hi("Conditional", { fg = c.magenta })
hi("Repeat", { fg = c.magenta })
hi("Label", { fg = c.blue })
hi("Operator", { fg = c.blue5 })
hi("Keyword", { fg = c.cyan, italic = false })
hi("Exception", { fg = c.magenta })
hi("PreProc", { fg = c.cyan })
hi("Include", { fg = c.cyan })
hi("Define", { fg = c.cyan })
hi("Macro", { fg = c.cyan })
hi("Type", { fg = c.blue })
hi("StorageClass", { fg = c.blue })
hi("Structure", { fg = c.blue })
hi("Typedef", { fg = c.blue })
hi("Special", { fg = c.blue })
hi("SpecialChar", { fg = c.blue })
hi("Delimiter", { fg = c.blue })
hi("Tag", { fg = c.blue })
hi("Todo", { fg = c.bg, bg = c.yellow })
hi("Error", { fg = c.red_error })
hi("Underlined", { underline = true })

-- Treesitter
hi("@variable", { fg = c.fg_muted })
hi("@variable.builtin", { fg = c.red })
hi("@variable.parameter", { fg = c.yellow })
hi("@variable.parameter.builtin", { fg = "#d3c2ab" })
hi("@constant", { link = "Constant" })
hi("@constant.builtin", { link = "Special" })
hi("@module", { link = "Include" })
hi("@module.builtin", { fg = c.red })
hi("@label", { fg = c.blue })
hi("@string", { link = "String" })
hi("@string.regexp", { fg = c.blue6 })
hi("@string.escape", { fg = c.magenta })
hi("@string.special", { link = "SpecialChar" })
hi("@string.special.url", { link = "Underlined" })
hi("@character", { link = "Character" })
hi("@character.special", { link = "SpecialChar" })
hi("@boolean", { link = "Boolean" })
hi("@number", { link = "Number" })
hi("@number.float", { link = "Float" })
hi("@type", { link = "Type" })
hi("@type.builtin", { fg = c.blue_muted })
hi("@attribute", { link = "PreProc" })
hi("@attribute.builtin", { link = "Special" })
hi("@property", { fg = c.teal })
hi("@function", { link = "Function" })
hi("@function.builtin", { link = "Special" })
hi("@constructor", { fg = c.magenta })
hi("@operator", { fg = c.blue5 })
hi("@keyword", { fg = c.purple, italic = false })
hi("@punctuation", { link = "Delimiter" })
hi("@punctuation.special", { fg = c.blue5 })
hi("@comment", { link = "Comment" })
hi("@comment.error", { link = "DiagnosticError" })
hi("@comment.warning", { link = "DiagnosticWarn" })
hi("@comment.note", { link = "DiagnosticInfo" })
hi("@comment.todo", { link = "Todo" })
hi("@tag", { link = "Label" })
hi("@tag.tsx", { fg = c.red })
hi("@tag.builtin.tsx", { fg = c.red })
hi("@tag.attribute.tsx", { fg = c.blue00 })
hi("@markup", { link = "Special" })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = false })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.underline", { underline = true })
hi("@markup.heading", { link = "Title" })
hi("@markup.link", { fg = c.teal })
hi("@markup.raw", { link = "String" })

-- Blink.cmp
hi("BlinkCmpMenu", { fg = c.fg_bright, bg = c.bg_float })
hi("BlinkCmpMenuBorder", { fg = c.bg, bg = c.bg_float })
hi("BlinkCmpDoc", { fg = c.fg_bright, bg = c.bg_float })
hi("BlinkCmpDocBorder", { fg = c.bg, bg = c.bg_float })
hi("BlinkCmpLabel", { fg = c.fg_bright })
hi("BlinkCmpLabelMatch", { fg = c.accent, bold = true, underline = true })
hi("BlinkCmpLabelDescription", { fg = "#bdbdbd" })

-- Mini.pick
hi("MiniPickMatchRanges", { fg = c.accent, bold = true, underline = true })
hi("MiniPickPrompt", { fg = c.fg_bright, bg = c.bg_dark })
hi("MiniPickPromptCaret", { fg = c.fg_bright, bg = c.bg_dark })
hi("MiniPickPromptPrefix", { fg = c.fg_bright, bg = c.bg_dark })

-- Oil
hi("OilNormal", { fg = c.fg_bright, bg = c.bg })

-- Statusline
hi("StatusLine", { fg = c.sl_fg, bg = c.bg_statusline })
hi("StatusLineNC", { fg = c.sl_fg_nc, bg = c.bg_statusline })
hi("StatusLineMode", { fg = c.sl_fg, bg = c.bg_statusline, bold = true })
hi("StatusLineGit", { fg = c.sl_fg, bg = c.bg_statusline })
hi("StatusLinePath", { fg = c.sl_fg, bg = c.bg_statusline })
hi("StatusLineError", { fg = c.sl_error, bg = c.bg_statusline, bold = true })
hi("StatusLineWarn", { fg = c.sl_warn, bg = c.bg_statusline, bold = true })
hi("StatusLinePos", { fg = c.sl_fg, bg = c.bg_statusline })
hi("StatusLineLspProgress", { fg = c.sl_lsp_progress, bg = c.bg_statusline, bold = true })
hi("StatusLineLspReady", { fg = c.sl_lsp_ready, bg = c.bg_statusline, bold = true })

-- QuickFixLine
hi("QuickFixLine", { bg = "#4f2f4f" })
