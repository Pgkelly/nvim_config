return {
	{
		"nvimdev/dashboard-nvim",
		enabled = true,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
	},
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			opts.presets.lsp_doc_border = true
		end,
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
				cmdline = {
					view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
					format = {
						cmdline = { pattern = "^:", icon = "=>>", lang = "vim", title = "" },
					},
				},
				views = {
					cmdline_popup = {
						size = {
							height = "auto",
							width = "60%",
						},
						position = {
							row = "65%",
							col = "50%",
						},
						border = {
							style = "single",
						},
					},
				},
			})
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
			background_colour = "#000000",
			render = "wrapped-compact",
		},
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = {},
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local helpers = require("incline.helpers")
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					local buffer = {
						ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
							or "",
						" ",
						{ filename, gui = modified and "bold,italic" or "bold" },
						" ",
						guibg = "#363944",
					}
					return buffer
				end,
			})
		end,
	},
	-- LazyGit integration with Telescope
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{
				";c",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		keys = {
			{

				"<leader>d",
				"<cmd>NvimTreeClose<cr><cmd>tabnew<cr><bar><bar><cmd>DBUI<cr>",
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- custom mappings
					vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
				end,
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 30,
					relativenumber = true,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
					custom = {
						"node_modules/.*",
					},
				},
				log = {
					enable = true,
					truncate = true,
					types = {
						diagnostics = true,
						git = true,
						profile = true,
						watcher = true,
					},
				},
			})

			-- if vim.fn.argc(-1) == 0 then
			-- 	vim.cmd("NvimTreeFocus")
			-- end
		end,
	},
}
