(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode 1)

(require 'yasnippet)
(yas-global-mode 1)

(require 'helm)
(require 'helm-descbinds)
(fset 'describe-bindings 'helm-descbinds)
(helm-mode 1)
(global-set-key (kbd "C-c h") 'helm-mini)

(provide 'autocomplete-pack)
