# Nvim dotfiles

![idelike](https://github.com/caesar0301/cool-dotfiles/blob/721440cf68751aabaa72da106a8f6770d8281964/assets/screenshot.png)

## Prerequisites

*   Nvim v0.9+ (for better experience with remote copy/paste, upgrade 0.10.0+)
*   Python 3.7.10+

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

The installed configuration structure:

*   `~/.config/nvim`: Nvim runtime directory
*   `~/.config/nvim/lua/packerman`: All Packer.nvim plugins declaration
*   `~/.config/nvim/plugin/`: Plugins setup
*   `~/.config/nvim/after/plugin`: User plugin preferences

### Post-installation

Afterwards, manually installation of plugins is performed by running command in vim:

```vim
:PackerInstall
```

Specifically, it is also required to configure `nvim-treesitter` language modules to suppress some warnings.

```vim
:TSInstall lua python go java vim vimdoc
```

Also, `formatter.nvim` depends on local installation of linter tools. Part of them are
installed by the `install.sh` script. The left should be installed manually:

    brew install bufbuild/buf/buf  # for proto

Several env arguments are optional to be configured to use Java language server and google formatter:

**jdt-language-server**

*   `JAVA_HOME_4JDTLS`: Java executable for `jdt-language-server`, default to use `JAVA_HOME`.
*   `JDTLS_INSTALL_HOME`: Installed home for `jdt-language-server`, default `~/.local/share/jdt-language-server`.

**google-java-formatter**

*   `JAVA_HOME_4GJF`: Java executable for `google-java-formatter`, default to use `JAVA_HOME`.
*   `GJF_JAR_FILE`: Installed jar path for `google-java-formatter`, default `~/.local/share/google-java-format/google-java-format-all-deps.jar`.

## Under the hood

Integrated plugins for fluent IDE:

*   LanguageServers management: `nvim-lspconfig`
*   Auto completion: code completion with `nvim-cmp`, grammar parsing with `nvim-treesitter`
*   Auto code format: `formatter.nvim`
*   Folder structure: `nvim-tree` and `barbar.nvim` for tabline
*   Code structure: `tagbar` (depends on external `universal-ctags`/`gotags` etc.)
*   Searching: general fuzzy finder with `nvim-telescope`
*   Git indicators: `vim-gitgutter`
