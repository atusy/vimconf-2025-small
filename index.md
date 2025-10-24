---
paginate: true
---

# Beyond Syntax Highlighting

## Unlocking the Power of Tree-sitter in Neovim

![height:1em](images/headphone.jpg) atusy

---

## ![height:1em](images/headphone.jpg) atusy

- <https://github.com/atusy>
- <https://x.com/Atsushi776>
- <https://blog.atusy.net>

---

## Special Thanks

- **3-shake Inc.**
    - The Bronze sponsor of VimConf 2025 small
    - My former employer
- **Atmark Inc.**
    - My current employer

---

## Questions

- Do you know tree-sitter?
- Do you use tree-sitter?
- Do you use tree-sitter in Vim?

---

## What is tree-sitter in general

- **Parsing library** (enough for today)
- More specifically, a parser generator tool & an incremental parsing library
    - supports on diverse programming languages
    - fast enough to react text changes
    - robust user experience under syntax errors

---

## What is tree-sitter in Neovim/Vim?

- In Neovim
    - Builtin feature to support syntax-aware featues, e.g. syntax highlighting
- In Vim
    - Opt-in feature to enable syntax highlighting ([mattn/vim-treesitter](https://github.com/mattn/vim-treesitter))

---

## Is tree-sitter for syntax highlighting?

- No, tree-sitter is just a parsing library
- Applicable to variety of syntax-aware features
    - Highlighting
    - Code folding
    - Smart selection (e.g., function definition)
    - Outline

---

## What happens by parsing?

- Identify node type of a region
    - function definition, string literal, assignment expression, ...
- Identify hierarchical structure of nodes
- Allow querying nodes by type and structure

---

## Today's goal

Be aware of tree-sitter as a tool to build your own workflow by

- Exploring usecases beyond syntax highlighting
- Showing insightful tree-sitter integration patterns
- Developing treesitter-ls, a language server

---

## What I don't cover today

- Details of configurations and plugin development
- Deep dive into tree-sitter internals

---

## Usecases by Neovim-builtin features

Let's learn

- Usage
- Key concepts
- Insight

from variety of features

---

### How many are the builtin?

<style scoped>
ol, p { font-size: 1.9rem }
</style>

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

### The answer is ... 7/10

- There are more builtin features
- The power of tree-sitter is already unlocked in Neovim!!
- If you use Vim, sorry for inconvenience..., but I have a good news today

---

### Syntax Highlighting

![bg fit](images/example-highlight.png)

---


### Syntax Highlighting

- Usage
    - `vim.treesitter.start()` enables tree-sitter-based syntax highlighting

---

### Syntax Highlighting

- Key concepts
    - **Parser** determines code structure
        - e.g., `"foo"` is `string` node
    - **Query** captures what to highlight
        - e.g., `(string) @string`
    - **Captures** are equal to highlight groups
        - e.g., `:hi @string guifg=Black`

---

### Syntax Highlighting

- Demo with `examples/url.py` and `runtime/queries/python/highlights.scm`
    1. Highlight nothing
    1. Highlight `comment` and `string`
    1. Highlight all `string_content` in `string`
    1. Highlight only URL-like `string_content`

---

### Syntax Highlighting

- Example 1
    - Query `string` nodes

```query
; node    ->  capture (highlight group)
(string)      @string
```

---

### Syntax Highlighting

- Example 2
    - Query URL-like `string_content`
        - by testing nest pattern and regex

``` query
(
  string (string_content) @string.special.url
  (#match? @string.special.url "^https?://\\S+$")
)
```

<!--
Demo scenario

- Open examples/url.py
    - Start with blank query
    - Add `((string) @string)`
    - Add `((string) (string_content) @string.special.url)`
    - Update the above to `((string) (string_content) @string.special.url) (#match? @string.special.url "^https?://\\S+$")`
-->

---

### Syntax Highlighting

- Insight
    - Query can capture complex pattern of nodes
        - e.g., nest pattern and regex pattern
    - Query is customizable
    - Users can define what to highlight per filetype without parser modification

---

### Code folding with foldexpr

- Usage
    - Enables structure-aware code folding based on syntax tree

```vim
:set foldmethod=expr
:set foldexpr=v:lua.vim.treesitter.foldexpr()
```

---

### Code folding with foldexpr

- Key concepts
    - Query determins what to fold
        - e.g., `(function_definition) @fold`
    - Neovim determines how to fold
        - by calculating fold levels of the captures

---

### Code folding with foldexpr

- Insight
    - Users can customize foldable nodes per filetype without parser modification

---

<!-- ### Language Injections -->

![bg fit](images/example-injection.png)

---

### Language Injections

- Usage
    - Apply tree-sitter features to embedded languages by recursive parsing
        - e.g., highlight code blocks

---

### Language Injections

- Key concepts
    - Query determines what to inject
        - embedded source codes as `@injection.content`
        - corresponding languages as `@injection.language`

---

### Language Injections

- Example 1
    - Parse markdown code blocks

```query
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)
```

---

### Language Injections

- Example 2 <!-- optional -->
    - Parse URL-like strings as URIs

```query
(
  (string_content) @injection.content
  (
      #match? @injection.content 
      "^[a-zA-Z][a-zA-Z0-9]*://\\S+$"
  )
  (#set! injection.language "uri")
)
```

---

### Language Injections

- Insight
    - Opens door to apply language-specific features (highlighting, folding, etc.) to embedded content

---

### Context-aware popup menu

![bg fit](images/example-popupmenu.png)

---

### Context-aware popup menu

<!-- [Source in Neovim](https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/lua/vim/_defaults.lua?plain=1#L487-L489) -->

- Usage
    - Right-click popup menu shows context-specific actions
- Example
    - "Open in web browser" for URL-related nodes

---

### Context-aware popup menu

- Key concepts
    - Query assigns `url` metadata to nodes
    - Lua code tests if the node has `url` metadata

```query
(
  (inline_link
      (link_destination) @_url
  ) @_label
  (#set! @_label url @_url)
)
```

<!-- [Source in Neovim](https://github.com/neovim/neovim/blob/a04c73ca071fdc2461365a8a10a314bd0d1d806d/runtime/queries/markdown_inline/highlights.scm?plain=1#L94-L96) -->


---

### Context-aware popup menu

- Insight
    - Set **metadata** to detemine complex pattern of what to process

---

## Quick summary 1

- Neovim has variety of tree-sitter powered features
- **Query-based approach** is a common pattern
    - Queries define **what** to process
    - Neovim APIs define **how** to process
- **Customize queries** to extend query-based behavior

---

## Tips

- View parse results with `:InspectTree`
- Test query with `:EditQuery`
- Find query examples at
  <https://github.com/nvim-treesitter/nvim-treesitter/tree/main>
- Find documents by `:h treesitter`


---

## Usecases by plugins

Some of my favorites...

---

### Navigate and highlight matching keywords

[andymass/vim-matchup](https://github.com/andymass/vim-matchup)

- Usage
    - Navigate and highlight matching keywords (if/endif, def/end, quotes, etc.)

---

### Navigate and highlight matching keywords

- Key concepts
    - Find keywords based on original queries
    - Loads queries with own file name, `matchup.scm`, and avoids conflicts with other plugins

---

### Navigate and highlight matching keywords

- Example from .../queries/lua/**matchup.scm**

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

- Key concepts
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

- Key concepts
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

- Key concepts
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
    - Highlgiht nodes that satisfies user-specified callback functions or `@tsnodemarker` capture
    - Supports highlighting to the end of the line

---

### Extra highlight for special nodes

- Examples
    - Highlight markdown fenced code blocks
    - Highlight nested function definitions

<!-- show demo what happens if highlight is done only by builtin feature -->

---

### Extra highlight for special nodes

- Key concepts
    - Find a node that satisfies one of
        - `@tsnodemarker` highlight capture
        -  User-defined callback functions
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

## Quick summary 2

- Vast variety of plugins uses tree-sitter
- Tree-sitter integration has **diverse approaches**
    - query
    - parser
    - callback
    - tree-traversal

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

### Language servers provide intelligence tools

- Go to Definition
- Find References
- Folding Range
- Selection Range
- Rename
- Semantic Tokens


---

### Typical language servers are language-specific

such as ...

- pyright (Python)
- tsserver (TypeScript/JavaScript)
- rust-analyzer (Rust)


---

### Are language servers language-specific?

- No, not necessarily
- [copilot-language-server](https://www.npmjs.com/package/@github/copilot-language-server) provides AI-powered code completions for any language
- [treesitter-ls](https://github.com/atusy/treesitter-ls) can support any language given a tree-sitter parser and queries

---

### Can treesitter-ls provide intelligence tools?

Yes, for example:

- Semantic Tokens (higihlighting)
- Go to Definition
- Find References
- Folding Range
- Selection Range
- Rename


---

### Will treesitter-ls replace language-specific servers?

No, because ...

- Some require deeper semantic understanding
    - e.g., type checking, linting, code actions, ...
- [treesitter-ls](https://github.com/atusy/treesitter-ls) capable features can be better provided by language-specific servers
    - e.g., scope-aware go to definition

---

### Why treesitter-ls?

To unlock various possibilities:

1. Unlock **availability** to any LSP-capable editor
    - Allows Bram's Vim users to enjoy tree-sitter features
    - Editors may even omit builtin syntax highlighting, which tend to be essential

---

### Why treesitter-ls?

2. Unlock **gaps** in language-specific servers
    - Provide consistent Folding, SelectionRange, and SemanticTokens where absent in language-specific servers
    - People may **forget about which server supports which feature**

---

### Why treesitter-ls?

3. Unlock **difficulty** to support niche or emerging languages
    - Just ship a tree-sitter parser + queries instead of a full server
    - Developer productivity **boost for new languages**


---

### Why treesitter-ls?

4. Unlock **injected-language workflows**
    - Use tree-sitter injections for code blocks, template strings, and DSLs
    - By [treesitter-ls](https://github.com/atusy/treesitter-ls) itself being LSP-client
        - Receive LSP-config from editor, and attach language servers for injected languages automatically

---

## ENJOY!!

- Syntax-aware features are powerful
    - e.g., highlighting, code folding, outline, sticky scroll, range selection, and more
- Tree-sitter helps building your usecases
- Star [atusy/treesitter-ls](https://github.com/atusy/treesitter-ls) that brings tree-sitter power to any LSP-capable editor

<style>
section {
    justify-content: flex-start;
    align-content: start;
font-size: 3rem;
}
</style>
