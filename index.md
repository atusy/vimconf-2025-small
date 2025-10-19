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
 7. Popup menu (e.g., Open URL)
 8. Indent
 9. Range selection/textobject
10. Sticky scroll

### The answer is ...

7/10, and there are more builtin features.

The power of tree-sitter is already unlocked in Neovim!!

### Syntax Highlighting

* Usage
    * `vim.treesitter.start()` enables tree-sitter-based syntax highlighting
* Implementation
    * Queries capture syntax nodes and assign highlight groups
    * User can extend by adding custom queries

```query
; Example 1: Highlight URL-like literal strings
; ~/.config/nvim/after/queries/python/highlights.scm
;; extends
(
  (string) ; node type
  @string  ; capture name (highlight group)
)

(
  (string_content) @string.special.url
  (#lua-match? @string.special.url "^https?://%S+$")
)
```

```query
; Example 2: Highlight inner function definitions
; ~/.config/nvim/after/queries/python/highlights.scm
;; extends
(
  (
     function_definition
     body: (
       block (function_definition) @function.inner
     )
  )
)
```

* Insight
    * Query-based highlighting allows fine-grained customization beyond language defaults
    * Predicates like `#lua-match?` enable pattern-based highlighting without parser changes

### Code folding with foldexpr

* Usage
    * `:set foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()`
    * Enables structure-aware code folding based on syntax tree
* Implementation
    * Queries define which node types should be foldable
    * `#trim!` directive removes whilespace from the fold range boundaries <!-- :h treesitter-directive-trim! -->

```query
; ~/.config/nvim/after/queries/markdown/folds.scm
((section) @fold (#trim! @fold))
;((list) @fold (#trim! @fold))
;((fenced_code_block) @fold (#trim! @fold))
```

* Insight
    * Users can customize foldable structures per filetype without parser modification

### Language Injections

* Usage
    * Enable syntax highlighting and parsing for embedded languages
        * Examples: code blocks in markdown, URLs in strings, SQL in code comments
* Implementation
    * Injection queries specify language and content regions
    * `@injection.language` and `@injection.content` captures define boundaries

```query
; Example 1: Parse markdown code blocks
; https://github.com/nvim-treesitter/nvim-treesitter/blob/846d51137b8cbc030ab94edf9dc33968ddcdb195/runtime/queries/markdown/injections.scm#L1-L4
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)
```

```query
; Example 2: Parse URL-like strings as URIs
(
  (string_content) @injection.content
  (#vim-match? @injection.content "^[a-zA-Z][a-zA-Z0-9]*:\/\/\\S\+$")
  (#set! injection.language "uri")
)
```

* Insight
    * Opens door to apply filetype-specific features (highlighting, folding, etc.) to embedded content

### Outline with `gO`

<https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/lua/vim/treesitter/_headings.lua?plain=1#L9-L14>

* Usage
    * Outlines headings in `vimdoc` and `markdown` files
* Implementation
    * uses custom queries to capture heading nodes

```lua
-- TODO(clason): use runtimepath queries (for other languages)
local heading_queries = {
  vimdoc = [[
    (h1 (heading) @h1)
    (h2 (heading) @h2)
    (h3 (heading) @h3)
    (column_heading (heading) @h4)
  ]],
```

* Insight
    * Query-based approach allows separation of concerns
        * Query defines **what** to process (headings)
        * Lua code defines **how** to process (outline display)
    * Opens door for user-defined queries as well

### Context-aware popup menu

<https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/lua/vim/_defaults.lua?plain=1#L487-L489>

* Usage
    * Right-click popup menu shows context-specific actions
        * Example: "Open URL by browser" appears only when cursor is on URL
* Implementation
    * Lua code examines if the node has `url` metadata
    * Queries use `#set!` directive to attach metadata to nodes

```query
; https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/queries/markdown_inline/highlights.scm?plain=1#L94-L96
((uri_autolink) @_url
  (#offset! @_url 0 1 0 -1)
  (#set! @_url url @_url))
```

* Insight
    * Query-based approach allows separation of concerns
        * The choice of **capture name** and **metadata** is up to developers
    * Custom metadata can power actions like "Run test", "Open docs", or "Preview"

### Quick summary

* Neovim implements variety of tree-sitter powered features
* Most features **separate** concerns by the **query-based approach**
    * Queries define **what** to process
    * Lua code defines **how** to process
* The query-based approach allows **user-custom queries** while keeping source code intact

## Usecases by plugins

### Navigate and highlight matching keywords

[andymass/vim-matchup](https://github.com/andymass/vim-matchup)

* Usage
    * Navigate and highlight matching keywords (if/endif, def/end, quotes, etc.)
* Implementation
    * Find keywords based on original queries
    * Use `matchup.scm` as query file name to avoid conflict with other plugins, and loads it with `vim.treesitter.query.get_file({lang}, "matchup")`

```query
(
  for_statement
  "do" @open.loop
  "end" @close.loop
) @scope.loop
```

* Insight
    * Like outline and popup menu, query-based approach allows language-agnostic implementation
    * Plugin-specific query files is a good pattern to avoid conflicts among multiple plugins

### Show context after functions, methods, statements, etc.

[haringsrob/nvim_context_vt](https://github.com/haringsrob/nvim_context_vt)

* Usage
    * Shows virtual text of the current context after functions, methods, statements, etc.
* Implementation
    * Distinguish nodes to show context by hard-coded list of node types
    * Still extensible via Lua-based configuration
    * Avoids requirement of queries per language
      <https://github.com/andersevenrud/nvim_context_vt/blob/fadbd9e57af72f6df3dd33df32ee733aa01cdbc0/lua/nvim_context_vt/config.lua#L19-L58>
* Insight
    * Parser-based approach can provide extensibility with less setup
    * Parser-based approach can be less language-specific because parsers tend to share common node types

### Sticky scroll

[nvim-treesitter/nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)

* Usage
    * Keep function/class headers visible at top of window while scrolling
    * Similar to IDE sticky headers feature
* Implementation
    * Use queries to capture context nodes (`@context`)
    * Just show first line of `@context` capture as is
        * No need to know nest level

```query
; markdown
; https://github.com/nvim-treesitter/nvim-treesitter-context/blob/41847d3dafb5004464708a3db06b14f12bde548a/queries/markdown/context.scm#L2
((section) @context)
```

* Insight
    * Yet another example of query-based approach
    * Similar to outline, but does not care nest level

### Auto close keywords

[RRethy/nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)

* Usage
    * Automatically insert closing keywords (end, endif, fi, etc.)
    * Example: Typing `if ... then` in lue automatically adds `end`
* Implementation
    * `endwise.scm` query to identify opening keywords, and specify corresponding closing keywords
    * `endwise`-directive
* Insight

### Label-hinting for region selections

[treemonkey.nvim](https://github.com/atusy/treemonkey.nvim)

* Usage
    * Show label hints for quickly selecting tree-sitter nodes
    * Use two-step selection to avoid ambiguity of overlapping label hints
* Implementation
    * Get node range of anscestor nodes by traversing syntax tree from the cursor position
* Insight
    * The tree structure is only the interest
        * no interest in node types or query-captured names

### Extra highlight for special nodes

[tsnode-marker.nvim](https://github.com/atusy/tsnode-marker.nvim)

* Usage
    * Highlgiht nodes that satisfies user-specified callback functions
    * Supports highlighting to the end of the line
        * not just the node range
        * useful for highlighting function definitions, markdown codeblcocks, etc.
* Implementation
    * Pass node at the cursor to user-defined callback functions
    * Applies additional highlights via extmarks
* Insight
    * Callback based approach allows flexible customization beyond query capabilities

### And more...

* Outlines
    * [stevearc/aerial.nvim](https://github.com/stevearc/aerial.nvim)
* Textobjects
    * [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
* Commenting
    * [nvim-mini/mini.comment](https://github.com/nvim-mini/mini.comment)
    * [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) + [JoosepAlviste/nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)

### Quick summary

* Power of tree-sitter applies to vast variety of plugins
* Plugins demonstrate **diverse approaches** to tree-sitter integration
    * **Query-based**
        * separates concerns
            * what to process (queries)
            * how to process (Lua code)
        * requires query per lanugae, but highly declarative
    * **Parser-based**
        * requires Lua code to do everything
        * allows (partially) language-agnostic logic
            * because there are common node types across languages
    * **Callback-based**
        * requires user-defined Lua functions
        * allows maximum flexibility
    * **Tree-traversal**
        * applicable iff only tree structure matters

## Yet another approach to bring tree-sitter power to editors

🚧 **Treesitter-ls** 🚧

A WIP language server powered by tree-sitter

<https://github.com/atusy/treesitter-ls>

### What are language servers?

lua-language-server, rust-analyzer, ...

They provide language intelligence tools

* Go to Definition
* Find References
* Folding Range
* Selection Range
* Rename
* Semantic Tokens

### Are language servers language-specific?

No, not necessarily.

**copilot-language-server** is a language-agnostic language server
that provides AI-powered code completions for any language.
<https://www.npmjs.com/package/@github/copilot-language-server>

and **treesitter-ls** is also a language-agnostic language server
that can support any language given a tree-sitter parser and queries.

### Can treesitter-ls provide language intelligence tools?

Yes, for example:

* Semantic Tokens
* Go to Definition
* Find References
* Folding Range
* Selection Range
* Rename

### Why treesitter-ls?

It unlocks various possibilities:

* Unlock Tree-sitter features for **any LSP-capable editor**
    * Only an LSP client is required
    * Allows Bram's Vim users to enjoy tree-sitter features
    * Editors may even omit builtin syntax highlighting, which tend to be essential feature

* Unlock **gaps** in language-specific servers
    * Provide consistent Folding, SelectionRange, and SemanticTokens where absent in language-specific servers
    * People may **forget about which server supports which feature**

* Unlock fast support for **niche or emerging languages**
    * Just ship a Tree-sitter parser + queries instead of a full server
    * Developer productivity **boost for new languages**

* Unlock **injected-language workflows**
    * Use Tree-sitter injections for code blocks, template strings, and DSLs

## ENJOY!!

* Tree-sitter is more than syntax highlighting
* Tree-sitter helps implement variety of syntax-aware usecases
    * e.g., code folding, outline, context-aware actions, sticky scroll, and more
    * with various appraches: query-based, parser-based, callback-based, tree-traversal-based
* Treesitter-ls aims to bring tree-sitter power to any LSP-capable editor

