;;; emacs-config -- my emacs configuration
;;;
;;; By Xiaming Chen <chenxm35@gmail.com>
(setq user-emacs-directory "~/.config/emacs/")

;; Global options
(setq enable-filemanager-pack t)
(setq enable-autocomplete-pack t)
(setq enable-statistics-pack t)
(setq enable-marklang-pack t)
(setq enable-academic-pack nil)
(setq enable-lisp-pack t)
(setq enable-ai-pack t)

;; Extra load-path
(dolist (directory '("lisp" "plugins"))
  (let ((default-directory (expand-file-name directory user-emacs-directory)))
    (setq load-path
          (append
           (let ((load-path (copy-sequence load-path))) ; Shadow
             (add-to-list 'load-path default-directory)
             (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
                 (normal-top-level-add-subdirs-to-load-path))
             load-path)
           load-path))))

;; Redirect custom-file and custom functions
(setq custom-file (expand-file-name "lisp/custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
(require 'custom-functions)

;;--------------------------------------------
;;  Configure MELPA
;;--------------------------------------------

;; Install melpa per se.
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Configure use-package
(if (not (package-installed-p 'use-package))
  (progn
    (when (not package-archive-contents)
      (package-refresh-contents))
    (package-install 'use-package)))
(require 'use-package)

;;; theme and icons
(package-install 'zenburn-theme)
(package-install 'all-the-icons)

;;; efficiency
(package-install 'drag-stuff)
(package-install 'multiple-cursors)

;;; file manager
(when enable-filemanager-pack
  (package-install 'projectile)
  (package-install 'neotree)
  (require 'filemanager-pack))

;;; autocomplete
(when enable-autocomplete-pack
  (package-install 'auto-complete)
  (package-install 'flycheck)
  (package-install 'helm)
  (package-install 'helm-descbinds)
  (package-install 'yasnippet)
  (require 'autocomplete-pack))

;;; statistics
(when enable-statistics-pack
  (package-install 'ess)
  (package-install 'r-autoyas)
  (require 'statistics-pack))

;;; academic writings
(when enable-academic-pack
  (package-install 'auctex)
  (package-install 'auto-complete-auctex)
  (package-install 'latex-preview-pane)
  (package-install 'latex-math-preview)
  (package-install 'zotelo)
  (require 'acacemic-pack))

;;; markdown langs
(when enable-marklang-pack
  (package-install 'markdown-mode)
  (package-install 'yaml-mode)
  (require 'marklang-pack))

;;; lisp
(when enable-lisp-pack
  (package-install 'slime)
  (package-install 'paredit)
  (package-install 'rainbow-delimiters)
  (require 'lisp-pack))

;;; AI assistant
(when enable-ai-pack
  (package-install 'gptel)
  (require 'ai-pack))

;;--------------------------------------------
;; Configure EMACS
;;--------------------------------------------

;;---------------
;; User Interface
;;---------------

;; customize user interface.
(when (display-graphic-p)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (scroll-bar-mode 0))
(setq inhibit-startup-screen t)

;; theme
(load-theme 'zenburn t)

;; don't blink the cursor
(blink-cursor-mode 0)

;; show line and column number
(setq linum-format "%d ")
(column-number-mode 1)

;; always use spaces, not tabs, when indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; indentation styles
(setq c-basic-offset 4)
(setq c-default-style (quote (
    (c-mode . "bsd")
    (java-mode . "java")
    (awk-mode . "awk")
    (other . "gnu"))))

;; word wrap at specific column number
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook
  '(lambda() (set-fill-column 79)))

;; wrap line respecting words
(global-visual-line-mode nil)

;; require final newlines in files when they are saved
(setq require-final-newline nil)

;; add a new line when going to the next line
(setq next-line-add-newlines nil)

;; each line of text gets one line on the screen (i.e., text will run off
;; the left instead of wrapping around onto a new line)
(setq-default truncate-lines 1)

;; truncate lines even in partial-width windows
(setq truncate-partial-width-windows 0)

;; highlight parentheses when the cursor is next to them
(require 'paren)
(setq show-paren-delay 0)
(show-paren-mode 1)

;;------
;; Fonts
;;------

;; set default font size
(set-face-attribute 'default nil :height 160)

;; text decoration
(require 'font-lock)
(global-font-lock-mode 1)
(global-hi-lock-mode nil)
(setq jit-lock-contextually 1)
(setq jit-lock-stealth-verbose 1)

;; ignore case when searching
(setq-default case-fold-search 1)

;; if there is size information associated with text, change the text
;; size to reflect it
(size-indication-mode 1)

;;--------
;; Windows
;;--------

;; language
(setq current-language-environment "English")

;; Set window title to full file name
(setq frame-title-format '("%b %+%+ %f"))

;; default window width and height
(defun custom-set-frame-size ()
  (add-to-list 'default-frame-alist '(height . 40))
  (add-to-list 'default-frame-alist '(width . 81)))
(custom-set-frame-size)
(add-hook 'before-make-frame-hook 'custom-set-frame-size)

;; window modifications
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;;-------
;; System
;;-------

;; set command key to be meta instead of option
(if (system-is-mac)
    (setq mac-command-modifier 'meta))

;; turn on mouse wheel support for scrolling
(require 'mwheel)
(mouse-wheel-mode 1)

;; disable backup
(setq backup-inhibited nil)

;; disable auto save
(setq auto-save-default nil)

;; access remove content via SSH
;; just do "C-x C-f //user@remoteserver:remote-path"
(setq tramp-default-method "ssh")

;; open compressed file automatically
(auto-compression-mode 1)

;; set PATH, because we don't load .bashrc
(if window-system (set-exec-path-from-shell-PATH))

;; load local env values for emacs terminal
(setq shell-command-switch "-ic")
(setenv "PATH"
  (concat "/usr/texbin" ":"
    (getenv "PATH")))


;; optimize auto backup
(defvar --backup-directory (concat user-emacs-directory "autosave"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t
      backup-by-copying t
      version-control t
      delete-old-versions t
      delete-by-moving-to-trash t
      kept-old-versions 6
      kept-new-versions 9
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 200
      )
(setq auto-mode-alist
      (append
       (list
        '("\\.\\(vcf\\|gpg\\)$" . sensitive-minor-mode)
        )
       auto-mode-alist))

;;------------
;; Keybindings
;;------------

;; help shortcut
(global-set-key [f1] 'help-command)

;; duplicate whole line by C-d
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "C-d") 'duplicate-line)

;; drag-stuff shortcuts
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;;---------
;; Spelling
;;---------

;; syntax flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; spelling check
(setq ispell-program-name "aspell")
(dolist
    (hook
     '(text-mode-hook
       rst-mode-hook
       change-log-mode-hook
       log-edit-mode-hook
       TeX-mode-hook
       ))
  (add-hook
   hook (lambda () (flyspell-mode 0))))
