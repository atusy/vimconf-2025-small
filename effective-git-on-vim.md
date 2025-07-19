## Title

Turn your Vim/Neovim into an effective Git TUI.

## Abstract

Having tough time using Git CLI?
Let's turn your Vim/Neovim into an effective Git TUI (Text User Interface) that works seamlessly with your workflow.

As a showcase, I will present my personal workflow and its underlying thoughts.
My workflow relies on small pieces of ideas that are easy to understand and use, rather than a single monolithic plugin.
Thus, audience can pick and choose the pieces that fit their own workflow.
In many cases, audience can achieve the ideas with their favorite plugins, not necessarily the ones I use.

Yes, audience can turn "their" Vim/Neovim into an effective Git TUI! No need to copy "my" Neovim!

## Self promotion for reviewers

I have been sharing tips and tricks on using Neovim as a Git TUI with community for a while.
Also, I have been contributed to vim-gin to enhance its usability for my own workflow, and to share the feature with the community.

That said, I am well-experienced and am a suitable speaker for this topic.

My favorite tips and tricks are below.

* Shortcuts to frequently used Git commands
    * mapping CTRL-G to a prefix key for Git commands
    * fuzzy finding commands from a predefined list with telescope.nvim
* Well-informed experience on writing commit messages
    * showing context of the changes (diff, status, and logs) besides the commit message by using vim-gin
    * autocompleting commit-prefixes and recent commit messages with ddc.vim
* Quick interactions with changes within a current buffer with gitsigns.nvim
    * showing signs for added/modified/deleted lines
    * jumping to the next/previous hunk
    * staging and unstaging hunks
* and more...
    * open/stage/unstage modified files with fuzzy finder, telescope.nvim
    * instantly fixup and reword commits with vim-gin
    * fine controls on staging/unstaging diffs with vim-gin

Many of these rely on the plugins, but does not require the audience to use the same plugins.
For example, telescope.nvim can be replaced with mini.nvim or ddu.vim, and gitsigns.nvim can be replaced with vim-gitgutter.

That is what I mean by "turn your Vim/Neovim into an effective Git TUI".

The underlying thoughts of my techniques have universal appeal to the audience, regardless of their current setup.

