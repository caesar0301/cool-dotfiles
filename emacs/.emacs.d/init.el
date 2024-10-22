;;; emacs-config -- my emacs configuration
;;;
;;; By Xiaming Chen <chen@xiaming.me>

;; Global options
(setq enable-theme-pack t)
(setq enable-ide-pack t)
(setq enable-autocomplete-pack t)
(setq enable-statistics-pack t)
(setq enable-marklang-pack t)
(setq enable-academic-pack nil)
(setq enable-lang-python t)
(setq enable-lang-lisp t)

;; melpa package manager
(add-to-list 'load-path "~/.emacs.d/melpa")
;; basic common utilities
(add-to-list 'load-path "~/.emacs.d/base")
;; plugin settings
(add-to-list 'load-path "~/.emacs.d/plugins")

(require 'melpa-settings)
(require 'custom-functions)
(setq custom-file "~/.emacs.d/base/custom.el")
(load custom-file)
(require 'basic-settings)
