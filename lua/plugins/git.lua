return {
  "lewis6991/gitsigns.nvim",

  config = true,
  event = "BufReadPost",
  keys = {
    { "<leader>gj", "<cmd>lua require('gitsigns').next_hunk()<CR>" },
    { "<leader>gk", "<cmd>lua require('gitsigns').prev_hunk()<CR>" },
    { "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<CR>" },
    { "<leader>gu", "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>" },
    { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<CR>" },
    { "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<CR>" },
    { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<CR>" },
    { "<leader>gl", "<cmd>lua require('gitsigns').blame_line()<CR>" },
  },
}
