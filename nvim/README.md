# Nvim dotfiles

![idelike](https://github.com/caesar0301/cool-dotfiles/blob/721440cf68751aabaa72da106a8f6770d8281964/assets/screenshot.png)

## Prerequisites

* Nvim v0.9+
* Python 3.7.10+

## Installation

Clone the whole repo

```bash
git clone --depth=1 https://github.com/caesar0301/cool-dotfiles.git ~/.dotfiles
```

Install nvim configurations to `~/.config/nvim` by running:

```bash
sh nvim/install.sh
```

By default, soft links would be created for future convenient update. You can change the default behaviour with option `-f` to copy all configurations to `~/.config/nvim`.

Sudo permissions are required to install necessaries dependencies used by nvim plugins.

## Configure Plugins

After nvim configs installation, manually installation of plugins is performed by running command in vim:

```vim
:PackerInstall
```

Specifically, it is also required to configure `nvim-treesitter` language modules to suppress some warnings.

```vim
:TSInstall lua python go java
```

### Plugins for IDE experience

* LanguageServers management: `nvim-lspconfig`
* Auto completion: code completion with `nvim-cmp`, grammar parsing with `nvim-treesitter`
* Auto code format: `formatter.nvim`
* Folder structure: `nvim-tree`
* Code structure: `tagbar` (depends on external `universal-ctags`/`gotags` etc.)
* Searching: fuzzy finder with `fzf` (<leader>fw), search everywhere (<leader>fW) with `the_silver_searcher`, general fuzzy finder with `nvim-telescope`
* Git indicators: `vim-gitgutter`

## Configuration Structures

* `~/.config/nvim`: Default installation of all configs
* `~/.config/nvim/lua/plugins.lua`: All plugins declaration
* `~/.config/nvim/plugin/`: Plugins setup in Lua
* `~/.config/nvim/vim`: Plugin configurations in Vim script

## Shortcuts

To see all shortcuts via
```vim
:map
```
