return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {},
        ts_ls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.stdpath("data")
                  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                languages = { "vue" },
              },
            },
          },
        },
      },
    },
  },
}
