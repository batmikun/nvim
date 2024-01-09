return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/trouble.nvim" },

			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "saadparwaiz1/cmp_luasnip" },
			{
				"Saecki/crates.nvim",
				event = { "BufRead Cargo.toml" },
				opts = {
					src = {
						cmp = { enabled = true },
					},
				},
			},

			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },

			{ "folke/neodev.nvim" },

			{ "b0o/schemastore.nvim" },
		},
		config = function()
			------------------------------ START CMP ------------------------------------------
			vim.api.nvim_set_hl(0, "CmpGhoshText", { link = "Comment", default = true })
			local winhighlight = {
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
			}

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").filetype_extend("typescriptreact", { "html" })

			local cmp = require("cmp")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(winhighlight),
					documentation = cmp.config.window.bordered(winhighlight),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-x>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "nvim_lua", group_index = 1 },
					{ name = "luasnip", group_index = 2 },
					{ name = "crates", group_index = 3 },
				}, {
					{ name = "path", max_item_count = 3 },
				}),
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				enabled = function()
					local context = require("cmp.config.context")
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
				experimental = {
					native_menu = false,
					ghost_text = true,
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,

						function(entry1, entry2)
							local _, entry1_under = entry1.completion_item.label:find("^_+")
							local _, entry2_under = entry2.completion_item.label:find("^_+")
							entry1_under = entry1_under or 0
							entry2_under = entry2_under or 0
							if entry1_under > entry2_under then
								return false
							elseif entry1_under < entry2_under then
								return true
							end
						end,

						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path", max_item_count = 5 },
				}, {
					{ name = "cmdline", max_item_count = 5 },
				}),
			})
			------------------------------ END CMP ------------------------------------------
			------------------------------ START LSP ----------------------------------------
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

			local lsp_installed = {
				"astro",
				"cssls",
				"clangd",
				"cmake",
				"dockerls",
				"elixirls",
				"gopls",
				"html",
				"htmx",
				-- "jsonls",
				-- "lua_ls",
				"marksman",
				"neocmake",
				"ocamllsp",
				-- "pyright",
				"ruff_lsp",
				-- "rust_analyzer",
				"sqlls",
				"svelte",
				"tailwindcss",
				"taplo",
				-- "tsserver",
				-- "yamlls",
				"zls",
			}

			require("neodev").setup({})

			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			require("lspconfig").pyright.setup({
				capabilities = capabilities,
			})

			require("lspconfig").ols.setup({})

			require("lspconfig").jsonls.setup({
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			require("lspconfig").yamlls.setup({
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})

			for _, lsp in pairs(lsp_installed) do
				require("lspconfig")[lsp].setup({
					capabilities = capabilities,
				})
			end

			------------------------------ END LSP ------------------------------------------
			------------------------------ START DIAG -----------------------------------------------

			local default_diagnostic_config = {
				virtual_text = false,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			}

			vim.diagnostic.config(default_diagnostic_config)

			------------------------------ END DIAG -----------------------------------------------
		end,
	},

	-- TYPESCRIPT
	{
		"pmizio/typescript-tools.nvim",
		event = { "BufReadPost *.js", "BufReadPost *.jsx", "BufReadPost *.ts", "BufReadPost *.tsx" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- RUST
	{
		"simrat39/rust-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = { "BufReadPost *.rs" },
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Hover action
						vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<Leader>cag", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim", -- show hints when writing function arguments
		event = { "InsertEnter" },
		opts = {
			bind = true,
			noice = true,
			max_height = 20,
			zindex = 1,
			always_trigger = true,
			floating_window_above_cur_line = true,
			floating_window_off_x = function(info)
				local cur_pos = vim.api.nvim_win_get_cursor(0)[2] + 1
				local x_off = info.x_off or -vim.trim(vim.api.nvim_get_current_line():sub(1, cur_pos)):len()
				local win_width = vim.api.nvim_win_get_width(0) - 4
				local origin = math.min(120, win_width)
				return origin - x_off - cur_pos
			end,
			extra_trigger_chars = { "(", ",", "\n" },
		},
	},

	-- PYTHON
	{
		"stevanmilic/nvim-lspimport",
		ft = { "python" },
	},
	{
		"AckslD/swenv.nvim",
		config = function()
			require("swenv").setup({
				get_venvs = function(venvs_path)
					return require("swenv.api").get_venvs(venvs_path)
				end,
				venvs_path = "/Users/batmi/Library/Caches/pypoetry/virtualenvs/",
				post_set_venv = function()
					vim.cmd("LspRestart")
				end,
			})
		end,
		keys = {
			{
				"<leader>pv",
				mode = { "n" },
				function()
					require("swenv.api").pick_venv()
				end,
				desc = "Select Python Env",
			},
		},
	},
}
