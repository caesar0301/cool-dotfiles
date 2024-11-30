;;; Set a few top-level variables.
(tpl:setq-default top-level:*history* 1000)
(tpl:setq-default top-level:*print-length* 20)
(tpl:setq-default top-level:*print-level* 5)
(tpl:setq-default top-level:*zoom-print-level* 3)
(tpl:setq-default top-level:*zoom-print-length* 3)
(tpl:setq-default top-level:*exit-on-eof* t)

;;; Have packages print with their alternate-name instead of the package
;;; name.
(tpl:setq-default *print-package-alternate-name* t)

;;; Allow concise printing of shared structure.
(tpl:setq-default *print-circle* t)

;;; Use the Composer package if it is available.
(eval-when (eval compile load)
  (when (find-package :wt)
    (use-package :wt)))

;;; quicklisp
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))
