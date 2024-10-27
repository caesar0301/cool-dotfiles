;;---------------;
;;; lisp mode  ;;;
;;---------------;

;;-------
;; slime
;;-------
(require 'slime)
;(setq inferior-lisp-program "sbcl")
;; Allegro CL in modern mode
(setq inferior-lisp-program "mlisp")

(slime-setup '(slime-fancy slime-quicklisp slime-asdf))

;; keymaps
(add-hook 'slime-load-hook
          (lambda ()
            (define-key slime-prefix-map (kbd "M-h") 'slime-documentation-lookup)))

;;-------
;; lispy
;;-------
; Enable lispy automatically for certain modes
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
; Enable lispy for eval-expression
(defun conditionally-enable-lispy ()
  (when (eq this-command 'eval-expression)
    (lispy-mode 1)))
(add-hook 'minibuffer-setup-hook 'conditionally-enable-lispy)

(provide 'lisp-settings)
