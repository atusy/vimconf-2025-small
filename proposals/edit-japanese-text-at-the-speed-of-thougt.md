## Title

Toward Editing Japanese Text at the Speed of Thought

## Abstract

Japanese text has unique characteristics that blocks our edits at the speed of thought.

* large character set
* no-spaced word/phrase boundaries

Fortunately, Vim/Neovim are powerful and extensible modal editors.

In the talk, I will explain why these characterstics are problematic, and how can we overcome them in Vim/Neoivm.

For example,

* romaji-based search to overcome motion within large character set
* machine-learning-based segmentation to detect word/phrase boundaries
* SKK for input and completion of Japanese text
* matchpairs for easy navigation of Japanese brackets and quotes

## Self promotion for reviewers

I am well-experienced in editing Japense text in Neovim.
A good example is my blog <https://blog.atusy.net/>.
I have posted 131 posts in the past 3 years since 2023.
Not only the count, but also the content is important.
Some of the posts shares tips and tricks on editing Japanese text in Neovim as shown below.

* BudouxによりNeovimのWモーションを拡張し、日本語文章の区切りに移動させる
* SKKの接頭辞・接尾辞変換をvim-skk/skkeletonに追加した
* 日本語の「っ」から始まる送り仮名とSKK+AZIKによる日本語入力に関する考察
* mini.aiで日本語の括弧の中身をrepeatableに編集する
* オレのNeovim見て！ 2024

Also, I have been authoring and contributing to various Neovim plugins that enhances editing Japanese text.

* https://github.com/atusy/jab.nvim
    * migemo-based motion plugin (f-motions and incremental search)
* https://github.com/atusy/budoux.nvim
    * machine-learning-based phrase segmentation plugin (w-motions)
* https://github.com/vim-skk/skkeleton
    * SKK input method plugin

These activities makes me a suitable and unique speaker for this topic.

