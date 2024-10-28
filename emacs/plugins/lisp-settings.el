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

(provide 'lisp-settings)
