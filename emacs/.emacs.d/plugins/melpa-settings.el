;;------------------
;;  Configure MELPA
;;------------------

;; Install
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Configure use-package
(if (not (package-installed-p 'use-package))
  (progn
    (when (not package-archive-contents)
      (package-refresh-contents))
    (package-install 'use-package)))
(require 'use-package)

;;; themes
(when enable-theme-pack
  (package-install 'solarized-theme)
  (package-install 'darcula-theme)
  (package-install 'all-the-icons)
  ;;; settings
  (require 'all-the-icons-settings))

;;; IDE
(when enable-ide-pack
  (package-install 'projectile)
  (package-install 'neotree)
  ;;; settings
  (require 'neotree-settings)
  (require 'ide-settings))

;;; autocomple
(when enable-autocomplete-pack
  (package-install 'auto-complete)
  (package-install 'flycheck)
  (package-install 'helm)
  (package-install 'helm-descbinds)
  (package-install 'yasnippet)
  ;;; settings
  (require 'yasnippet) (yas-global-mode 1)
  (require 'auto-complete-settings)
  (require 'helm-settings))

;;; statistics
(when enable-statistics-pack
  (package-install 'ess)
  (package-install 'r-autoyas)
  (package-install 'matlab-mode)
  ;;; settings
  (require 'matlab-settings)
  (require 'r-settings))

(when enable-marklang-pack
  (package-install 'markdown-mode)
  (package-install 'yaml-mode)
  ;;; settings
  (require 'markdown-settings)
  (require 'yaml-settings))

;;; academic writings
(when enable-academic-pack
  (package-install 'auctex)
  (package-install 'auto-complete-auctex)
  (package-install 'latex-preview-pane)
  (package-install 'latex-math-preview)
  (package-install 'zotelo)
  ;;; settings
  (require 'latex-settings)
  (require 'zotero))

;;; python
(when enable-lang-python
  (package-install 'jedi)
  ;;; settings
  (require 'python-settings))

;;; lisp
(when enable-lang-lisp
  (package-install 'slime)
  (package-install 'lispy)
  ;;; settings
  (require 'lisp-settings))

(provide 'melpa-settings)
