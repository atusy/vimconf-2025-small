## Title

Turn your Vim/Neovim into an effective Git TUI.

## Abstract

This proposal talks about how to interact effectively with Git in Vim/Neovim.
By presenting my workflow and its underlying thoughts, I hope to help others set up their own effective Git workflow in Vim/Neovim.

* Quick interactions with changes within a current buffer with gitsigns.nvim
    * showing signs for added/modified/deleted lines
    * jumping to the next/previous hunk
    * staging and unstaging hunks
* Well-informed experience on writing commit messages
    * showing context of the changes (diff, status, and logs) with vim-gin
    * autocompleting with commit-prefixes and recent commit messages with ddc.vim
* Shortcuts to frequently used Git commands
    * mapping CTRL-G to a prefix key for Git commands
    * fuzzy finding commands from a predefined list with telescope.nvim
* and more...
    * open/stage/unstage modified files with fuzzy finder, telescope.nvim
    * instant fixup and reword of commits with vim-gin
    * fine controls on staging/unstaging diffs with vim-gin

## Target Audience

* people who wants to turn Vim/Neovim into their TUI that works in Vim/Neovim
* people who are using TUI outside Vim/Neovim, but looking for a fully Vim/Neovim-friendly keymappings
* people who are already using plugins 


