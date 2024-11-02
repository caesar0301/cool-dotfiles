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


;;-----------
;; Allegro CL
;;-----------
(load "/home/chenxm/.local/opt/acl/eli/fi-site-init")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; the following bit of code allows you to prevent from exiting emacs with
;;; subprocesses running.

(setq kill-emacs-hook
  (function
   (lambda ()
     (save-some-buffers)
     (my-query-kill-processes))))

(setq my-ignorable-processes
  '("server" "display-time" "*shell*"))

(defun my-query-kill-processes ()
  (let ((ps (process-list)))
    (while ps
      (if (or (member-equal (process-name (car ps)) my-ignorable-processes)
	      (not (eq 'run (process-status (car ps))))
	      (eq 'exit (process-status (car ps)))
	      (progn
		(condition-case ()
		    (progn
		      (switch-to-buffer (process-buffer (car ps)))
		      (delete-other-windows)
		      (end-of-buffer))
		  (error nil))
		(y-or-n-p
		 (format "Kill process %s? " (process-name (car ps))))))
	  (condition-case ()
	      (kill-process (car ps))
	    (error (kill-buffer (process-buffer (car ps))))))
      (setq ps (cdr ps))))
  (sleep-for 1))

(defun member-equal (item list)
  "same as common lisp (member item list :test #'equal)"
  (let ((ptr list)
        (done nil)
        (result '()))
    (while (not (or done (atom ptr)))
      (cond ((equal item (car ptr))
             (setq done t)
             (setq result ptr)))
      (setq ptr (cdr ptr)))
    result))

(provide 'lisp-settings)
