# Beyond Syntax Highlighting: Unlocking the Power of Tree-sitter in Neovim

atusy

## atusy

* <https://github.com/atusy>
* <https://blog.atusy.net>

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

* In Neovim
    * builtin feature to interact with syntax tree, especially for syntax highlighting
* In Vim
    * opt-in feature to enable syntax highlighting ([mattn/vim-treesitter](https://github.com/mattn/vim-treesitter))

## Is tree-sitter for syntax highlighting?

* No, tree-sitter is just a parsing library
* **syntax** highlight is just an application of obtained abstract **syntax** tree
* We can do more with AST
    * Code folding
    * Smart selection of `if` statement, function definition, and so on

## Usecases in Neovim

How many are the builtin
among the 10 tree-sitter powered features?

 1. Syntax highlighting
 2. Code folding
 3. Code completions
 4. Outline
 5. Pairing keywords (like matchit/matchup)
 6. Toggling comments
 7. Context-aware menu (e.g., Open URL)
 8. Indent
 9. Range selection/textobject
10. Sticky scroll

## The answer is ...

7/10, and there are more builtin features

* For Neovim users,
    * the power of tree-sitter is already unlocked
    * the more power comes with 3rd party plugins
* For Vim users,
    * the power of tree-sitter is still locked

## Unlock the power of tree-sitter

by unleashing your imaginations!!

Let's start from exploring fantastic usecases!!

There are basically sS


## Syntax Highlighting

`vim.treesitter.start()`,
the typical usecase still has room to extend

* URL paths in literal string

```query
; ~/.config/nvim/after/queries/python/highlights.scm
(
  (string_content) @string.special.url
  (#lua-match? @string.special.url "^https?://%S+$")
)
```

* Nested function definitions

```query
; ~/.config/nvim/after/queries/python/highlights.scm
(
  (
     function_definition
     body: (
       block (function_definition) @illuminate
     )
  )
)
```

## Code folding with foldexpr

`:set foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()`
is also extensible

* Switching foldable node types

```query
((section) @fold (#trim! @fold))
;((list) @fold (#trim! @fold))
;((fenced_code_block) @fold (#trim! @fold))
```

## Language Injections

To **parse** various languages in a language
(e.g., JavaScript in HTML)

# Extending some features by editing queries

* highlights
    * extensible
    * on nested if statement
* injections
    * Users can extend (no need to contribute)
    * we can add patterns of injections (e.g., mini.test provides a way to highlight vim commands in child process)
* indents
* locals

4 approaches

* Editing queries (highlights, folds, locals, injections)
* Using `vim.treesitter` APIs
* Implementing parsers
* Implementing `treesitter-ls`, a language server
