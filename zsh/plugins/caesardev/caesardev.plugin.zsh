#!/usr/bin/bash
# shellcheck disable=SC1090,SC2154

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

source ${0:h}/alias.zsh
source ${0:h}/dev_env.zsh
source ${0:h}/git.zsh
source ${0:h}/misc.zsh