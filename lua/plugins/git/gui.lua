return {
  {                        -- ← mở table plugin
    'SuperBo/fugit2.nvim',
    build = false,
    opts = {
      width = 100,
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit',
        dependencies = { 'stevearc/dressing.nvim' },
      },
    },
    cmd  = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph', 'Fugit2Rebase' },
    keys = {
      { '<leader>gu', '<cmd>Fugit2<cr>', mode = 'n', desc = 'Fugit2' },
    },
  },                       -- ← đóng table plugin
}