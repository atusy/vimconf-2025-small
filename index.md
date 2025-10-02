# Beyond Syntax Highlighting: Unlocking the Power of Tree-sitter in Neovim

atusy

## atusy

* https://github.com/atusy
* https://blog.atusy.net

## Special Thanks

* **3-shake Inc.**
    * The Bronze sponsor of VimConf 2025 small
    * My previous employer
* **At mark Inc.**
    * My current employer

## Questions

* Do you know tree-sitter?
* Do you use tree-sitter?
* Do you use tree-sitter in Vim?

## What is tree-sitter in general?

* A parser generator tool and an incremental parsing library
    * generous supports on diverse programming languages
    * fast enough to react text changes
    * robust user experience under syntax errors

## What is tree-sitter in Neovim/Vim?

* For Neovim
    * builtin feature to interact with syntax tree, especially for syntax highlighting
* For Vim
    * opt-in feature to enable syntax highlighting ([mattn/vim-treesitter](https://github.com/mattn/vim-treesitter))

## Is tree-sitter for syntax highlighting?

* No, tree-sitter is just a parsing library
* **syntax** highlight is just an application of obtained abstract **syntax** tree
* We can do more with AST
    * Code folding
    * Smart selection of `if` statement, function definition, and so on

## Usecases in Neovim

How many out of 10 are the builtin?

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

## The answer is 8/10

* For Neovim users,
    * the power of tree-sitter is already unlocked
    * the more power comes with 3rd party plugins
* For Vim users,
    * the power of tree-sitter is still locked to 

## Unlock the power of tree-sitter

by unleashing your imaginations!!

Let's start from exploring fantastic usecases!!

# Extending some features by editing queries

* highlights
    * extensible
    * on nested if statement
* injections
    * Users can extend (no need to contribute)
    * we can add patterns of injections (e.g., mini.test provides a way to highlight vim commands in child process)
* indents
* locals


