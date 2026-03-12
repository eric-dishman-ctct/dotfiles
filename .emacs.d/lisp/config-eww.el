;; Remap keys in `eww-mode-map`.
(use-package eww
  :ensure nil
  :bind (:map eww-mode-map
              ("M-p" . my/previous-line)
              ("M-n" . my/next-line)))

(provide 'config-eww)
