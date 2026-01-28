(add-to-list 'load-path "/usr/local/src/emacs-reader/")
(require 'reader)
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . reader-mode))
(provide 'config-reader)
