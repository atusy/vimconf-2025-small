---
paginate: true
---

# Beyond Syntax Highlighting

## Unlocking the Power of Tree-sitter in Neovim

atusy

---

## atusy

- <https://github.com/atusy>
- <https://blog.atusy.net>

---

## Special Thanks

- **3-shake Inc.**
    - The Bronze sponsor of VimConf 2025 small
    - My previous employer
- **Atmark Inc.**
    - My current employer

---

## Questions

- Do you know tree-sitter?
- Do you use tree-sitter?
- Do you use tree-sitter in Vim?

---

## What is tree-sitter

---

### tree-sitter in general

A parser generator tool & an incremental parsing library

- supports on diverse programming languages
- fast enough to react text changes
- robust user experience under syntax errors

---

### tree-sitter in Neovim/Vim?

- In Neovim
    - builtin feature to interact with syntax tree, especially for syntax highlighting
- In Vim
    - opt-in feature to enable syntax highlighting ([mattn/vim-treesitter](https://github.com/mattn/vim-treesitter))

---

### Is tree-sitter for syntax highlighting?

- No, tree-sitter is just a parsing library
- Highlighting is just an application of obtained AST
- We can do more with AST
    - Code folding
    - Smart selection (e.g., `if` statement, function definition, and so on)
    - ...

---

## Today's talk

Unlocking the Power of Tree-sitter in Neovim by...

- Exploring various usecases beyond syntax highlighting
- Show insightful patterns of tree-sitter integration
- Introducing potential of treesitter-ls, a language server powered by tree-sitter

---

## What I don't cover today

- Details of configurations and plugin development
- Deep dive into tree-sitter internals

---

## Usecases by Neovim-builtin features

---

### How many are the builtin

<style scoped>
ol, p { font-size: 1.7rem }
</style>

among the 10 tree-sitter powered features?

 1. Syntax highlighting
 2. Code folding
 3. Outline
 4. Pairing keywords (like matchit/matchup)
 5. Toggling comments
 6. Popup menu (e.g., Open URL)
 7. Open help in browser
 8. Indent
 9. Range selection/textobject
10. Sticky scroll

---

### The answer is ...

7/10, and there are more builtin features.

The power of tree-sitter is already unlocked in Neovim!!

---

### Syntax Highlighting

- Usage
    - `vim.treesitter.start()` enables tree-sitter-based syntax highlighting
- Implementation
    - Queries capture syntax nodes and assign highlight groups
    - User can extend by adding custom queries

---

#### Syntax Highlighting

Example 1: Highlight URL-like literal strings

<!-- ~/.config/nvim/after/queries/python/highlights.scm -->

```query
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

---

#### Syntax Highlighting

Example 2: Highlight inner function definitions

<!-- ~/.config/nvim/after/queries/python/highlights.scm -->

```query
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

---

#### Syntax Highlighting

- Insight
    - Query-based highlighting allows fine-grained customization beyond language defaults
    - Predicates like `#lua-match?` enable pattern-based highlighting without parser changes

---

### Code folding with foldexpr

- Usage
    - `:set foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()`
    - Enables structure-aware code folding based on syntax tree

---

### Code folding with foldexpr

- Implementation
    - Queries define **foldable** node types
    - `#trim!` directive trims whilespace from the fold range boundaries <!-- :h treesitter-directive-trim! -->

<!-- ~/.config/nvim/after/queries/markdown/folds.scm -->

```query
((section) @fold (#trim! @fold))
;((list) @fold (#trim! @fold))
;((fenced_code_block) @fold (#trim! @fold))
```

---

### Code folding with foldexpr

- Insight
    - Users can customize foldable structures per filetype without parser modification

---

### Language Injections

- Usage
    - Recursively parse embedded languages and apply tree-sitter features
        - e.g., highlight markdown code blocks
- Implementation
    - Injection queries specify language and content regions
    - `@injection.language` and `@injection.content` captures define boundaries

---

### Language Injections

- Example 1: Parse markdown code blocks

```query
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)
```

[Source in nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/blob/846d51137b8cbc030ab94edf9dc33968ddcdb195/runtime/queries/markdown/injections.scm#L1-L4)

---

### Language Injections

```query
; Example 2: Parse URL-like strings as URIs
(
  (string_content) @injection.content
  (
      #vim-match?
      @injection.content
      "^[a-zA-Z][a-zA-Z0-9]*:\/\/\\S\+$"
  )
  (#set! injection.language "uri")
)
```

---

### Language Injections

- Insight
    - Opens door to apply filetype-specific features (highlighting, folding, etc.) to embedded content

---

### Outline with `gO`

[Source in Neovim](https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/lua/vim/treesitter/_headings.lua?plain=1#L9-L14)

- Usage
    - Outlines headings in `vimdoc` and `markdown`

---

### Outline with `gO`

- Implementation
    - Custom queries to capture heading nodes

```query
; vimdoc
(h1 (heading) @h1)
(h2 (heading) @h2)
(h3 (heading) @h3)
(column_heading (heading) @h4)
```

---

### Outline with `gO`


- Insight
    - Query-based approach separates concerns
        - Query defines **what** to process
          (headings)
        - Lua code defines **how** to process
          (outline display)

---

### Context-aware popup menu

[Source in Neovim](https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/lua/vim/_defaults.lua?plain=1#L487-L489)

- Usage
    - Right-click popup menu shows context-specific actions
        - Example: "Open URL by browser" appears only when cursor is on URL

---

### Context-aware popup menu

- Implementation
    - Lua code tests if the node has `url` metadata
    - `#set!` directive assigns node metadata

```query
((uri_autolink) @_url
  (#offset! @_url 0 1 0 -1)
  (#set! @_url url @_url))
```

[Source in Neovim](https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/queries/markdown_inline/highlights.scm?plain=1#L94-L96)


---

### Context-aware popup menu

- Insight
    - Query-based separates concerns
        - The choice of **capture name** and **metadata** is up to developers
    - Custom metadata can power actions like "Run test", "Open docs", or "Preview"

---

### Quick summary

- Neovim implements variety of tree-sitter powered features
- **Query-based approach** is a common pattern
    - Queries define **what** to process
    - Lua code defines **how** to process
- In this way, users can tweak behavior by **user-custom queries**

---

## Usecases by plugins

---

### Navigate and highlight matching keywords

[andymass/vim-matchup](https://github.com/andymass/vim-matchup)

- Usage
    - Navigate and highlight matching keywords (if/endif, def/end, quotes, etc.)

---

### Navigate and highlight matching keywords

- Implementation
    - Find keywords based on original queries
    - Loads queries with own file name, `matchup.scm`, and avoids conflicts with other plugins

---

### Navigate and highlight matching keywords

Example from .../queries/lua/**matchup.scm**

```query
(
  for_statement
  "do" @open.loop
  "end" @close.loop
) @scope.loop
```


---

### Navigate and highlight matching keywords

- Insight
    - Like outline and popup menu, query-based approach allows language-agnostic implementation
    - Plugin-specific query files is a good pattern to avoid conflicts among multiple plugins

---

### Show context after functions, methods, statements, etc.

[haringsrob/nvim_context_vt](https://github.com/haringsrob/nvim_context_vt)

- Usage
    - Shows virtual text of the current context after functions, methods, statements, etc.

---

### Show context after functions, methods, statements, etc.

- Implementation
    - List node types to show context
        - Hard coded, but still extensible
        - Avoiding queries per language with the help of common node types ([source](https://github.com/andersevenrud/nvim_context_vt/blob/fadbd9e57af72f6df3dd33df32ee733aa01cdbc0/lua/nvim_context_vt/config.lua#L19-L58))

---

### Show context after functions, methods, statements, etc.

- Insight
    - Parser-based approach can provide extensibility with less setup
    - Parser-based approach can be less language-specific because parsers tend to share common node types

---

### Sticky scroll

[nvim-treesitter/nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)

- Usage
    - Keep function/class headers visible at top of window while scrolling
    - Similar to IDE sticky headers feature

---

### Sticky scroll

- Implementation
    - Use queries to capture context nodes (`@context`)
    - Just show first line of `@context` capture as is
        - No need to know nest level unlike outline

---

### Sticky scroll

- Insight
    - Yet another example of query-based approach
    - Similar to outline, but does not care nest level

---

### Label-hinting for region selections

[treemonkey.nvim](https://github.com/atusy/treemonkey.nvim)

- Usage
    - Show label hints for quickly selecting tree-sitter nodes
    - Use two-step selection to avoid ambiguity of overlapping label hints

---

### Label-hinting for region selections

- Implementation
    - Get node range of anscestor nodes by traversing syntax tree from the cursor position

---

### Label-hinting for region selections

- Insight
    - The tree structure is only the interest
        - no interest in node types or query-captured names

---

### Extra highlight for special nodes

[tsnode-marker.nvim](https://github.com/atusy/tsnode-marker.nvim)

- Usage
    - Highlgiht nodes that satisfies user-specified callback functions
    - Supports highlighting to the end of the line

---

### Extra highlight for special nodes

- Examples
    - Highlight markdown fenced code blocks
    - Highlight nested function definitions

---

### Extra highlight for special nodes

- Implementation
    - Pass node at the cursor to user-defined callback functions
    - Applies additional highlights via extmarks

---

### Extra highlight for special nodes

- Insight
    - Callback based approach allows flexible customization beyond query capabilities

---

### And more...

1. Auto-close keywords
    - [RRethy/nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)
    - Example: Typing `if ... then` in Lua automatically adds `end`
2. Outlines
    - [stevearc/aerial.nvim](https://github.com/stevearc/aerial.nvim)

---


### And more...

3. Textobjects
    - [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
4. Commenting
    - [nvim-mini/mini.comment](https://github.com/nvim-mini/mini.comment)
    - [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) + [JoosepAlviste/nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)

---

### Quick summary

- Power of tree-sitter applies to vast variety of plugins
- Plugins demonstrate **diverse approaches** to tree-sitter integration

---

### Quick summary of approaches

1. **Query**-based approach
    - requires query per lanuguage, but highly declarative
2. **Parser-based**
    - requires Lua code to do everything
    - (partially) language-agnostic logic using common node types

---

### Quick summary of approaches

3. **Callback-based**
    - requires user-defined Lua functions
    - allows maximum flexibility
4. **Tree-traversal**
    - applicable iff only tree structure matters

---

## Yet another approach to bring tree-sitter power to editors

🚧 **Treesitter-ls** 🚧

A WIP language server powered by tree-sitter

<https://github.com/atusy/treesitter-ls>

---

### What are language servers

They provides language intelligence tools

- Go to Definition
- Find References
- Folding Range
- Selection Range
- Rename
- Semantic Tokens


---

### Typical language servers

are language-specific such as ...

- pyright (Python)
- tsserver (TypeScript/JavaScript)
- rust-analyzer (Rust)


---

### Are language servers language-specific?

- No, not necessarily.
- [copilot-language-server](https://www.npmjs.com/package/@github/copilot-language-server) provides AI-powered code completions for any language.
- **treesitter-ls** can support any language given a tree-sitter parser and queries.

---

### Can treesitter-ls provide language intelligence tools?

Yes, for example:

- Semantic Tokens (higihlighting)
- Go to Definition
- Find References
- Folding Range
- Selection Range
- Rename


---

### Will treesitter-ls replace language-specific servers?

- No, some require deeper semantic understanding
    - e.g., type checking, linting, code actions, ...
- No, treesitter-ls capable features can be better provided by language-specific servers
    - e.g., more accurate go to definition by understanding scopes

---

### Why treesitter-ls?

It unlocks various possibilities:

1. Unlock tree-sitter to **any LSP-capable editor**
    - Allows Bram's Vim users to enjoy tree-sitter features
    - Editors may even omit builtin syntax highlighting, which tend to be essential

---

### Why treesitter-ls?

2. Unlock **gaps** in language-specific servers
    - Provide consistent Folding, SelectionRange, and SemanticTokens where absent in language-specific servers
    - People may **forget about which server supports which feature**

---

### Why treesitter-ls?

3. Unlock fast support for **niche or emerging languages**
    - Just ship a Tree-sitter parser + queries instead of a full server
    - Developer productivity **boost for new languages**


---

### Why treesitter-ls?

4. Unlock **injected-language workflows**
    - Use Tree-sitter injections for code blocks, template strings, and DSLs

---

## ENJOY!!

- Tree-sitter is more than syntax highlighting
- Tree-sitter helps variety of syntax-aware usecases
    - e.g., code folding, outline, context-aware actions, sticky scroll, and more
- Treesitter-ls aims to bring tree-sitter power to any LSP-capable editor

<style>
section {
    justify-content: flex-start;
    align-content: start;
font-size: 3rem;
}
</style>
