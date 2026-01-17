-- Diffview configuration
-- Git diff viewer that opens in a dedicated tab
return {
  -- Disable <leader>gd from gitsigns to avoid conflict
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gd", false },
    },
  },
  -- Disable <leader>gd from snacks to avoid conflict
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gd", false },
    },
  },
  -- Diffview: enhanced Git diff and merge tool
  {
    "sindrets/diffview.nvim",
    -- Lazy-load on these commands
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      -- Open diffview in a new tab to keep current layout intact
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
    },
    opts = {
      -- Include untracked files in the file panel
      show_untracked = true,
    },
  },
}
