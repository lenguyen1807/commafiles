vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  
    use "wbthomason/packer.nvim"

    use "lewis6991/impatient.nvim"

    use "nvim-lua/plenary.nvim"

    -- Important plugin --
    
    use {'SirVer/ultisnips',
	    requires = {{'honza/vim-snippets', rtp = '.'}},
	}  

    use "lervag/vimtex"

    use "nvim-tree/nvim-tree.lua"

    use "nvim-tree/nvim-web-devicons"

    use { "nvim-treesitter/nvim-treesitter", 
	    run = ":TSUpdate",
	}

    use "windwp/nvim-autopairs"

    use "numToStr/Comment.nvim"

    use "psliwka/vim-smoothie"

    use "windwp/windline.nvim"

    -- Color scheme --

    use "ellisonleao/gruvbox.nvim"

    use 'folke/tokyonight.nvim' 

    -- Completion --
    
    use "hrsh7th/nvim-cmp"

    use 'hrsh7th/cmp-nvim-lsp'

    use 'hrsh7th/cmp-buffer' 

    use 'hrsh7th/cmp-path'

    use 'hrsh7th/cmp-cmdline'

    use 'quangnguyen30192/cmp-nvim-ultisnips'

    use "williamboman/nvim-lsp-installer"

    use 'neovim/nvim-lspconfig'

    use "onsails/lspkind-nvim"

end)
