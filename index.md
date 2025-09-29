# Beyond Syntax Highlighting: Unlocking the Power of Tree-sitter in Neovim

atusy


## Special Thanks

**3-shake Inc.**

* The Bronze sponsor of VimConf 2025 small
* My previous employer

## 

* Do you know treesitter?
* Do you use treesitter?
* Keep your hands if you are not Neovim users

## What is Tree-sitter?

* In general,
    * A parser generator tool and an incremental parsing library
        * generous supports on diverse programming languages
        * fast enough to react text changes
        * robust user experience under syntax errors
* For Neovim,
    * A key component syntax-related features, especially syntax highlighting
* For Vim...?
    * mattn has been working on to integrate tree-sitter based syntax highlighting

## Tree-sitter in Neovim

1. Syntax highlighting
1. Code folding
1. Code completions <!-- :h vim.treesitter.query.omnifunc -->
1. Outline headings and jumping around them
1. Tag identification
    * A help tag in help buffer related to the cursor position
1. Pairing keywords (like matchit/matchup)
1. Toggling comments
1. Context-aware menu (e.g., Open URL)
    <!-- -->
1. Indent <!-- nvim-treesitter -->
1. Range selection/textobject
1. Sticky scroll <!-- nvim-treesitter-context -->

## 
