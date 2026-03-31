return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          files = {
            hidden = true,  -- show dotfiles and hidden files
            ignored = true, -- show gitignored files (e.g. .env)
            exclude = { "node_modules", ".git", "dist", ".next", "build", ".cache", "__pycache__", ".venv", "venv", "target" },
          },
        },
      },
    },
  },
}
