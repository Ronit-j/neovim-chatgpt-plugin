return {
  {
    "rest-nvim/rest.nvim",
    lazy=false,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy=false,
  },
  {
    "Ronit-j/neovim-chatgpt-plugin/",
    dependencies = {"nvim-treesitter/nvim-treesitter", "rest-nvim/rest.nvim"},
    config = function()
      require("nvim-treesitter")
      require("gpt_helper.gpt_helper").setup()
    end
  },


}
