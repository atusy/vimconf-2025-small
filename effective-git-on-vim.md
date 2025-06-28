## Title

Turn your Vim/nevim into an effective Git TUI.

## Abstract

This proposal talks about how to interact effectively with Git in Vim/Neovim.
By presenting my workflow and its underlying thoughts, I hope to help others set up their own effective Git workflow in Vim/Neovim.

* CTRL-G as a prefix key for Git commands
* implementing command palette with fuzzy finder, telescope.nvim, as a shortcut to frequently used Git commands
* gitsigns.nvim
    * signs for added/modified/deleted lines
    * jumping to the next/previous hunk
    * staging/unstaging hunks
* vim-gin
* telescope.nvim
    * fuzzy find modified files to stage, unstage, or open
    * 

* implementing prefix completion for commit messages with ddc.vim
* implementing custom commit UI with vim-gin.

* autocompletion for prefixes of commit messages with ddc.vim

## Target Audience

* people who wants to turn Vim/Neovim into their TUI that works in Vim/Neovim
* people who are using TUI outside Vim/Neovim, but looking for a fully Vim/Neovim-friendly keymappings
* people who are already using plugins 


