--------------------------------------------------------------------------
-- null-ls: https://github.com/jose-elias-alvarez/null-ls.nvim
-- Use Neovim as a language server to inject LSP diagnostics, code actions,
-- and more via Lua.
--------------------------------------------------------------------------
local null_ls = safe_require('null-ls')
if not null_ls then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    debug = false,
    sources = {
        -----------------------------
        -- Code formatting
        -----------------------------
        -- HTML
        formatting.prettier.with({
            extra_args = {
                '--no-semi',
                '--single-quote',
                '--jsx-single-quote',
            },
        }),
        -- Lua
        formatting.stylua,
        -- Python
        -- formatting.autopep8,
        formatting.black,
        formatting.isort,
        -----------------------------
        -- Code diagnostic
        ---------------------------
        diagnostics.flake8.with({
            filetypes = {
                'python',
            },
        }),
        diagnostics.pylint,
        -- diagnostics.mypy,
    },
})
