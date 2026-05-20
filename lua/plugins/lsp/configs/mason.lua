-- ---@type NvPluginSpec
-- -- NOTE: Package installer
-- return {
--   "mason-org/mason.nvim",
--   event = {
--     "BufReadPost",
--     "BufNewFile",
--   },
--   init = function()
--     vim.keymap.set("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason | Installer", silent = true })
--   end,
--   cmd = {
--     "Mason",
--     "MasonInstall",
--     "MasonInstallAll",
--     "MasonUpdate",
--     "MasonUninstall",
--     "MasonUninstallAll",
--     "MasonLog",
--   },
--   opts = {
--     ui = {
--       border = vim.g.border_enabled and "rounded" or "none",
--       check_outdated_packages_on_open = false,
--       icons = {
--         package_pending = " ",
--         package_installed = " ",
--         package_uninstalled = " ",
--       },
--     },
--     registries = {
--       "github:nvim-java/mason-registry",
--       "github:mason-org/mason-registry",
--     },
--   },
--   dependencies = {
--     {
--       "mason-org/mason-lspconfig.nvim",
--       config = function()
--         vim.schedule(function()
--           local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
--           local ok_opts, opts = pcall(require, "config.lsp")
--           if not (ok_mason and ok_opts) then
--             return
--           end

--           -- Default config for all servers
--           vim.lsp.config("*", {
--             capabilities = opts.capabilities,
--             on_attach = opts.on_attach,
--           })

--           local excluded = { "ts_ls", "jdtls", "rust_analyzer" }

--           local function setup_servers()
--             for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
--               if not vim.tbl_contains(excluded, server) then
--                 -- Load server-specific settings if available
--                 local ok_settings, settings = pcall(require, "plugins.lsp.settings." .. server)
--                 if ok_settings then
--                   vim.lsp.config(server, settings)
--                 end
--                 vim.lsp.enable(server)
--               end
--             end

--             vim.lsp.enable "gdscript"
--           end

--           setup_servers()

--           -- This code snippet is from Lazyvim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L241-L251
--           local mr = require "mason-registry"
--           mr:on("package:install:success", function(pkg)
--             if pkg.spec.categories[1] == "LSP" then
--               vim.defer_fn(function()
--                 setup_servers()

--                 vim.notify("Auto-Enable: " .. pkg.name, vim.log.levels.INFO)
--                 -- retrigger FileType so buffer picks up the new server
--                 require("lazy.core.handler.event").trigger {
--                   event = "FileType",
--                   buf = vim.api.nvim_get_current_buf(),
--                 }
--               end, 100)
--             end
--           end)
--         end)
--       end,
--     },
--     {
--       "jay-babu/mason-nvim-dap.nvim",
--       config = function()
--         -- NOTE: Automatically handle debug adapters for you.
--         require("mason-nvim-dap").setup {
--           handlers = {
--             function(config)
--               require("mason-nvim-dap").default_setup(config)
--             end,
--           },
--         }
--       end,
--     },
--   },
-- }

---@type NvPluginSpec
-- NOTE: Package installer
return {
	"mason-org/mason.nvim",
	enabled = function()
		return not vim.g.no_ide
	end,
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	init = function()
		vim.keymap.set("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason | Installer", silent = true })
	end,
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonInstallAll",
		"MasonUpdate",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonLog",
	},
	opts = {
		ui = {
			border = vim.g.border_enabled and "rounded" or "none",
			check_outdated_packages_on_open = false,
			icons = {
				package_pending = " ",
				package_installed = " ",
				package_uninstalled = " ",
			},
		},
		registries = {
			"github:nvim-java/mason-registry",
			"github:mason-org/mason-registry",
		},
	},
	dependencies = {
		-- ──────────────────────────────────────────────
		-- LSP
		-- ──────────────────────────────────────────────
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
			config = function()
				local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
				local ok_opts, opts = pcall(require, "config.lsp")
				if not (ok_mason and ok_opts) then
					return
				end

				mason_lspconfig.setup({
					automatic_enable = false,
				})

				vim.lsp.config("*", {
					capabilities = opts.capabilities,
					on_attach = opts.on_attach,
				})

				local excluded = { "ts_ls", "jdtls", "rust_analyzer", "sqls" }
				local fallback_servers = {
					"html",
					"cssls",
					"tailwindcss",
					"eslint",
					"emmet_language_server",
					"stylelint_lsp",
					"biome",
					"vtsls",
					"vue_ls",
					"graphql",
					"gopls",
					"clangd",
					"sqlls",
					"lua_ls",
					"jsonls",
					"yamlls",
					"dockerls",
					"taplo",
					"pyright",
				}

				local function setup_servers()
					local servers = mason_lspconfig.get_installed_servers()
					if vim.tbl_isempty(servers) then
						servers = fallback_servers
					end

					for _, server in ipairs(servers) do
						if not vim.tbl_contains(excluded, server) then
							local ok_settings, settings = pcall(require, "plugins.lsp.settings." .. server)
							if ok_settings then
								vim.lsp.config(server, settings)
							end
							vim.lsp.enable(server)
						end
					end
					vim.lsp.enable("gdscript")
				end

				local function retrigger_current_filetype()
					local bufnr = vim.api.nvim_get_current_buf()
					if vim.bo[bufnr].filetype == "" then
						return
					end
					vim.api.nvim_exec_autocmds("FileType", {
						buffer = bufnr,
						modeline = false,
					})
				end

				setup_servers()
				retrigger_current_filetype()

				local mr = require("mason-registry")
				mr:on("package:install:success", function(pkg)
					if pkg.spec.categories[1] == "LSP" then
						vim.defer_fn(function()
							setup_servers()
							vim.notify("Auto-Enable: " .. pkg.name, vim.log.levels.INFO)
							retrigger_current_filetype()
						end, 100)
					end
				end)
			end,
		},

		-- ──────────────────────────────────────────────
		-- DAP
		-- ──────────────────────────────────────────────
		{
			"jay-babu/mason-nvim-dap.nvim",
			config = function()
				require("mason-nvim-dap").setup({
					automatic_installation = false,
					handlers = {
						function(config)
							require("mason-nvim-dap").default_setup(config)
						end,
					},
				})
			end,
		},

		-- ──────────────────────────────────────────────
		-- Linter & Formatter
		-- mason-tool-installer quản lý các tool không
		-- phải LSP: formatter, linter, và LSP bổ sung
		-- ──────────────────────────────────────────────
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			cmd = {
				"MasonToolsInstall",
				"MasonToolsUpdate",
				"MasonToolsClean",
			},
			config = function()
				require("mason-tool-installer").setup({
					ensure_installed = {
						-- ── LSP ──────────────────────────────────────
						-- Web: HTML / CSS / Tailwind / JS / TS
						"html-lsp",
						"css-lsp",
						"tailwindcss-language-server",
						"vtsls",
						"eslint-lsp",
						"emmet-language-server",
						"stylelint-language-server",
						"biome",
						"vue-language-server",
						"graphql-language-service-cli",

						-- Go
						"gopls",

						-- Java / Maven / Spring Boot
						"jdtls",
						"java-test",
						"spring-boot-tools",

						-- C / C++
						"clangd",

						-- Database
						"sqlls",
						"sqls",

						-- Lua (để viết config Neovim)
						"lua-language-server",

						-- Tiện ích chung
						"json-lsp",
						"yaml-language-server",
						"dockerfile-language-server",
						"taplo",
						"tree-sitter-cli",

						-- ── Formatter ────────────────────────────────
						-- Web stack: JS / TS / HTML / CSS / JSON / YAML / Markdown
						"prettier",

						-- Go
						"gofumpt",
						"goimports",

						-- Java
						"google-java-format",

						-- C / C++
						"clang-format",

						-- Lua
						"stylua",

						-- SQL
						"sqlfmt",
						"sql-formatter",
						"sqlfluff",

						-- Shell script
						"shfmt",

						-- ── Linter ───────────────────────────────────
						-- JS / TS / React / Next / NestJS
						-- no-config JS diagnostics, useful for loose .js files
						"quick-lint-js",
						-- typo diagnostics in comments and strings, e.g. bacground -> background
						"typos",
						-- daemon mode, nhanh hơn eslint-lsp
						"eslint_d",

						-- Go: meta-linter gộp ~100 linter
						"golangci-lint",

						-- C / C++
						"cpplint",

						-- Lua
						"luacheck",

						-- YAML (docker-compose, k8s, CI/CD)
						"yamllint",

						-- Dockerfile
						"hadolint",

						-- Shell script
						"shellcheck",
					},

					auto_update = false,
					run_on_start = false,
				})
			end,
		},
	},
}
