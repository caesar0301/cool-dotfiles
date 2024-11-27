;;-------
;; slime
;;-------
(require 'slime)

(load (expand-file-name "~/.roswell/lisp/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(slime-setup '(slime-fancy slime-quicklisp slime-asdf))

;; keymaps
(add-hook 'slime-load-hook
          (lambda ()
            (define-key slime-prefix-map (kbd "M-h") 'slime-documentation-lookup)))

(provide 'lisp-pack)
