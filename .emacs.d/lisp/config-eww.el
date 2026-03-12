;; Remap keys in `eww-mode-map`.
(use-package eww
  :ensure nil
  :bind (:map eww-mode-map
              ("M-p" . vader/previous-line)
              ("M-n" . vader/next-line)))

(provide 'config-eww)
