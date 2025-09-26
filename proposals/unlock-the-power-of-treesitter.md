## Title

Beyond Syntax Highlighting: Unlocking the Power of Tree-sitter in Neovim

## Abstract

Neovim users get benefits of beautiful syntax highlighting with Tree-sitter.
However, Tree-sitter can do much more than just syntax highlighting.
Once you understand it is actually an incremental parsing library, you may come up with various ways to enhance your text edit experience.

I will introduce some of my favorite use cases and their implementations (tree-sitter parser, query, and Neovim plugin).
Audience can try out these examples themselves, or use them as a starting point for their own creative ideas.

Here are some of the use cases I will cover:

* Select and edit syntactically meaningful regions
    * select a specific kind of nodes as text objects (e.g. function, class, etc.)
    * select a node that includes the cursor position with a help of easymotion-like labelling
* Add extra highights to your code
    * change the background color of code blocks in markdown files
    * emphasize URL paths in literal string
* and more
    * syntax-aware code folding
    * context-aware key mappings based on the node under the cursor

Also, I would like to introduce `treesitter-ls`, a tree-sittere-powered language server.
Although this is currently a work in progress, it is worth introducing as it potentially provides the power of tree-sitter to non-Neovim users.

## Self promotion for reviewers

I have been sharing tips and tricks on using Neovim with Tree-sitter for a while.
Some of them are powered by plugins I have developed myself.
Furthermore, I also have an experience of writing tree-sitter parsers and queries.

That said, I am well-experienced and am a suitable speaker for this topic.

Below are my blog posts related to Tree-sitter.

* Markdownのコードブロックとかテキストの文脈に合わせて背景色を変えるtsnode-marker.nvimを作った
    * https://blog.atusy.net/2023/04/19/tsnode-marker-nvim/
* テキストの折り畳みを彩る vim.treesitter.foldtext() を使ってみる
    * https://blog.atusy.net/2023/10/26/treesitter-foldtext/
* Neovimで文法に従ってコードを範囲選択するtreemonkey.nvimを作った
    * https://blog.atusy.net/2023/12/27/treemonkey-nvim/
* treesitterを使って閲覧中のヘルプのneovim.io版URLを発行する
    * https://blog.atusy.net/2025/05/05/neovim-io-help/
* Neovim 0.11でシンタックスハイライトがちらつく問題の回避策
    * https://blog.atusy.net/2025/05/07/workaround-nvim-async-ts-fliker/
* LuaのシンタックスハイライトはLanguage ServerのSemantic TokensよりTreesitterに任せたほうがよさげ
    * https://blog.atusy.net/2025/07/15/prefer-luadoc-to-luals-semantictokens/

I am also the author of `treesitter-ls`, a tree-sitter-powered language server <https://github.com/atusy/treesitter-ls>.
