(in-package user)
(load "/tmp/quicklisp.lisp")
(progn (if (not (probe-file "~/quicklisp"))
           (quicklisp-quickstart:install))
       (exit))
