return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Map astro to prettier
      astro = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
