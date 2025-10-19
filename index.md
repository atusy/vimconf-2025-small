# Beyond Syntax Highlighting: Unlocking the Power of Tree-sitter in Neovim

atusy

## atusy

* <https://github.com/atusy>
* <https://blog.atusy.net>

## Special Thanks

* **3-shake Inc.**
    * The Bronze sponsor of VimConf 2025 small
    * My previous employer
* **Atmark Inc.**
    * My current employer

## Questions

* Do you know tree-sitter?
* Do you use tree-sitter?
* Do you use tree-sitter in Vim?

## What is tree-sitter

### What is tree-sitter in general?

* A parser generator tool and an incremental parsing library
    * generous supports on diverse programming languages
    * fast enough to react text changes
    * robust user experience under syntax errors

### What is tree-sitter in Neovim/Vim?

* In Neovim
    * builtin feature to interact with syntax tree, especially for syntax highlighting
* In Vim
    * opt-in feature to enable syntax highlighting ([mattn/vim-treesitter](https://github.com/mattn/vim-treesitter))

### Is tree-sitter for syntax highlighting?

* No, tree-sitter is just a parsing library
* **syntax** highlight is just an application of obtained abstract **syntax** tree
* We can do more with AST
    * Code folding
    * Smart selection (e.g., `if` statement, function definition, and so on)
    * ...

## Today's talk

Unlocking the Power of Tree-sitter in Neovim by...

* Exploring various usecases beyond syntax highlighting
* Introducing potential of treesitter-ls, a language server powered by tree-sitter

## What I don't cover today

* Details of configurations and plugin development
* Deep dive into tree-sitter internals

## Usecases by Neovim-builtin features

### How many are the builtin

among the 10 tree-sitter powered features?

 1. Syntax highlighting
 2. Code folding
 4. Outline
 5. Pairing keywords (like matchit/matchup)
 6. Toggling comments
 7. Context-aware menu (e.g., Open URL)
 8. Indent
 9. Range selection/textobject
10. Sticky scroll

### The answer is ...

7/10, and there are more builtin features.

The power of tree-sitter is already unlocked in Neovim!!

### Syntax Highlighting

`vim.treesitter.start()`,
the typical usecase still has room to extend
by editing queries that capture syntax nodes and assign highlight groups.

* Highlight URL-like literal strings

```query
; ~/.config/nvim/after/queries/python/highlights.scm
(
  (string_content) @string.special.url
  (#lua-match? @string.special.url "^https?://%S+$")
)
```

* Highlight inner function definitions

```query
; ~/.config/nvim/after/queries/python/highlights.scm
(
  (
     function_definition
     body: (
       block (function_definition) @function.inner
     )
  )
)
```

### Code folding with foldexpr

`:set foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()`
is also extensible

* Select foldable node types

```query
; ~/.config/nvim/after/queries/markdown/folds.scm
((section) @fold (#trim! @fold))
;((list) @fold (#trim! @fold))
;((fenced_code_block) @fold (#trim! @fold))
```

### Language Injections

To **parse** various languages in a language

* Parse markdown code blocks

```query
; https://github.com/nvim-treesitter/nvim-treesitter/blob/846d51137b8cbc030ab94edf9dc33968ddcdb195/runtime/queries/markdown/injections.scm#L1-L4
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)
```

* Parse URL-like strings

```query
(
  (string_content) @injection.content
  (#vim-match? @injection.content "^[a-zA-Z][a-zA-Z0-9]*:\/\/\\S\+$")
  (#set! injection.language "uri")
)
```

* Parse literal string as URL

## Usecases by plugins

### Highlight, navigate, and operate on sets of matching text

[andymass/vim-matchup](https://github.com/andymass/vim-matchup)

### Commenting based on context

[numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
[JoosepAlviste/nvim-ts-context-commentstring](/Users/atusy/.local/share/chezmoi/dot_config/nvim/lua/plugins.lua)

### Show context after functions, methods, statements, etc.

[haringsrob/nvim_context_vt](https://github.com/haringsrob/nvim_context_vt)

### Sticky scroll

[nvim-treesitter/nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)

### Auto close keywords

like `end`, `endif`, `}` , etc

[AbaoFromCUG/nvim-treesitter-endwise](https://github.com/AbaoFromCUG/nvim-treesitter-endwise)

### Label-hinting for region selections

[treemonkey.nvim](https://github.com/atusy/treemonkey.nvim)

### Extra highlight for special nodes

[tsnode-marker.nvim](https://github.com/atusy/tsnode-marker.nvim)

### Outline view of symbols

[stevearc/aerial.nvim](https://github.com/stevearc/aerial.nvim)

### Textobjects

[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)

## Treesitter-ls

A language server powered by tree-sitter

### What are language servers?

lua-language-server, rust-analyzer, ...

They provide language intelligence tools

* Go to Definition
* Find References
* Folding Range
* Selection Range
* Rename
* Semantic Tokens

### Why treesitter-ls?

* Unlock Tree-sitter features for any LSP-capable editor
    * Only an LSP client is required
* Unlock gaps in language-specific servers
    * Provide consistent Folding, SelectionRange, and SemanticTokens where absent
* Unlock fast support for niche or emerging languages
    * Ship a Tree-sitter grammar + queries instead of a full server
* Unlock embedded/mixed-language workflows
    * Use Tree-sitter injections for code blocks, template strings, and DSLs
