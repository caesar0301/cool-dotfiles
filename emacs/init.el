;;; emacs-config -- my emacs configuration
;;;
;;; By Xiaming Chen <chenxm35@gmail.com>

;; Global options
(setq enable-theme-pack t)
(setq enable-ide-pack t)
(setq enable-autocomplete-pack t)
(setq enable-statistics-pack t)
(setq enable-marklang-pack t)
(setq enable-academic-pack nil)
(setq enable-lang-python t)
(setq enable-lang-lisp t)

;; Loading paths
(add-to-list 'load-path "~/.config/emacs/base")
(add-to-list 'load-path "~/.config/emacs/plugins")

;; Basic settings
(require 'melpa-settings)
(require 'custom-functions)
(setq custom-file "~/.config/emacs/base/custom.el")
(load custom-file)
(require 'basic-settings)

