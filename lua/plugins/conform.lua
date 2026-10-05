return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        java = { "google_java_format" },
        cpp = { "clang-format" }
        -- Conform will run multiple formatters sequentially
        -- You can customize some of the format options for the filetype (:help conform.format)
        -- Conform will run the first available formatter
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      formatters = {
        google_java_format = {
          command = "google-java-format",
          args = { "-r", "$FILENAME" },
          stdin = false,
        }
      }
    })
  end
}
