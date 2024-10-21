;;; emacs-config -- my emacs configuration
;;;
;;; By Xiaming Chen <chen@xiaming.me>

;; Global options
(setq enable-all-the-icons t)
(setq enable-auto-complete t)
(setq enable-camelcase t)
(setq enable-helm t)
(setq enable-ide t)
(setq enable-ido t)
(setq enable-latex t)
(setq enable-lisp t)
(setq enable-markdown t)
(setq enable-matlab t)
(setq enable-neotree t)
(setq enable-pig nil)
(setq enable-python t)
(setq enable-rstat nil)
(setq enable-scss nil)
(setq enable-web-dev nil)
(setq enable-yaml t)
(setq enable-yasnippet t)
(setq enable-zotero nil)

;; melpa package manager
(add-to-list 'load-path "~/.emacs.d/melpa")
(require 'melpa-settings)

;; basic common utilities
(add-to-list 'load-path "~/.emacs.d/base")
(require 'custom-functions)
(require 'basic-settings)
(setq custom-file "~/.emacs.d/settings/custom.el")
(load custom-file)

;; plugins
(add-to-list 'load-path "~/.emacs.d/plugins")

;; plugin settings
(when enable-all-the-icons (require 'all-the-icons-settings))
(when enable-auto-complete (require 'auto-complete-settings))
(when enable-camelcase (require 'camelcase-settings))
(when enable-helm (require 'helm-settings))
(when enable-ide (require 'ide-settings))
(when enable-ido (require 'ido-settings))
(when enable-latex (require 'latex-settings))
(when enable-lisp (require 'lisp-settings))
(when enable-markdown (require 'markdown-settings))
(when enable-matlab (require 'matlab-settings))
(when enable-neotree (require 'neotree-settings))
(when enable-pig (require 'pig-settings))
(when enable-python (require 'python-settings))
(when enable-rstat (require 'r-settings))
(when enable-scss (require 'scss-settings))
(when enable-web-dev (require 'web-dev-settings))
(when enable-yaml (require 'yaml-settings))
(when enable-yasnippet (require 'yasnippet) (yas-global-mode 1))
(when enable-zotero (require 'zotero))
