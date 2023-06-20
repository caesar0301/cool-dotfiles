;;---------------;
;;; lisp mode  ;;;
;;---------------;

;;-------
;; slime
;;-------
(require 'slime)
(setq inferior-lisp-program "sbcl")

(slime-setup '(slime-fancy slime-quicklisp slime-asdf))

;; keymaps
(add-hook 'slime-load-hook
          (lambda ()
            (define-key slime-prefix-map (kbd "M-h") 'slime-documentation-lookup)))

;;-------
;; lispy
;;-------
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

(provide 'lisp-settings)
