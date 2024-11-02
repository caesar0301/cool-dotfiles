;;---------------;
;;; lisp mode  ;;;
;;---------------;

;;-------
;; slime
;;-------
(require 'slime)

;; Allegro CL in modern mode
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "mlisp")

(slime-setup '(slime-fancy slime-quicklisp slime-asdf))

;; keymaps
(add-hook 'slime-load-hook
          (lambda ()
            (define-key slime-prefix-map (kbd "M-h") 'slime-documentation-lookup)))

;;------------
;; Allegro ELI
;;------------

; (setq aclisp-home "~/.local/opt/acl")
; (load (concat aclisp-home "/eli/fi-site-init"))

(provide 'lisp-settings)
