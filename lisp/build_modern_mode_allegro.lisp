;; mlisp:
(progn
  (build-lisp-image "sys:mlisp.dxl" :case-mode :case-sensitive-lower
                    :include-ide nil :restart-app-function nil)
  (when (probe-file "sys:mlisp") (delete-file "sys:mlisp"))
  (sys:copy-file "sys:alisp" "sys:mlisp"))
