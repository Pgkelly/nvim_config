return {
	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.g.sonokai_transparent_background = "2"
			vim.g.sonokai_enable_italic = "1"
			vim.g.sonokai_style = "atlantis"
			vim.g.sonokai_dim_inactive_windows = "1"
			vim.g.sonokai_show_eob = "0"
			vim.cmd.colorscheme("sonokai")
		end,
	},
}
