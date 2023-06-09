local null_ls = require("null-ls")

-- register any number of sources simultaneously
local sources = {
	null_ls.builtins.code_actions.gitsigns,

	-- lua
	null_ls.builtins.diagnostics.luacheck,
	null_ls.builtins.formatting.stylua,

	-- c, cpp
	null_ls.builtins.formatting.clang_format.with({
		"-i",
		"-style=google",
	}),

	-- web front
	null_ls.builtins.diagnostics.tsc.with({
		prefer_local = "node_modules/.bin",
	}),
	null_ls.builtins.diagnostics.stylelint.with({
		prefer_local = "node_modules/.bin",
	}),
	null_ls.builtins.formatting.stylelint.with({
		prefer_local = "node_modules/.bin",
	}),

	null_ls.builtins.code_actions.eslint_d.with({}),
	null_ls.builtins.diagnostics.eslint_d.with({}),
	null_ls.builtins.formatting.eslint_d,
	null_ls.builtins.formatting.prettierd.with({
		filetypes = {
			"css",
			"scss",
			"less",
			"html",
			"json",
			"yaml",
			"markdown",
			"graphql",
		},
	}),
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = sources,
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
