return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- nvim-treesitter's current main branch no longer provides the old
    -- `nvim-treesitter.configs` module.
    local treesitter = require("nvim-treesitter")
    local languages = {
      "json",
      "javascript",
      "yaml",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "cpp",
      "java",
    }

    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- The new plugin delegates highlighting and indentation to Neovim's
    -- built-in Tree-sitter APIs.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function()
        local ok = pcall(vim.treesitter.start)
        if not ok then
          return
        end

        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        if vim.bo.filetype == "yaml" then
          vim.wo.foldlevel = 99
        end
      end,
    })
  end,
}
