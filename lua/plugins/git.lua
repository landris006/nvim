return {
  "lewis6991/gitsigns.nvim",

  opts = {
    signs = {
      add          = { text = '+' },
      change       = { text = '~' },
      delete       = { text = '-' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '+' },
      change       = { text = '~' },
      delete       = { text = '-' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
  },
  event = "BufReadPost",
  keys = {
    { "<leader>gj", "<cmd>lua require('gitsigns').next_hunk()<CR>",       desc = "Preview next hunk" },
    { "<leader>gk", "<cmd>lua require('gitsigns').prev_hunk()<CR>",       desc = "Preview previous hunk" },
    { "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<CR>",      desc = "Stage hunk" },
    { "<leader>gu", "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", desc = "Undu stage hunk" },
    { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<CR>",      desc = "Reset hunk" },
    { "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<CR>",    desc = "Reset buffer" },
    { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<CR>",    desc = "Preview hunk" },
    { "<leader>gl", "<cmd>lua require('gitsigns').blame_line()<CR>",      desc = "Blame line" },
  },
}
