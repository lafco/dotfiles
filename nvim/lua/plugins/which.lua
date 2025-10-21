return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      {
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>w", group = "session" },
        { "<leader>s", group = "search" },
        { "<leader>o", group = "options" },
        { "<leader>l", group = "language" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
      },
    },
  },
}
