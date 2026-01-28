;; Remap the keys in eww-mode-map
(with-eval-after-load 'eww
  (define-key eww-mode-map (kbd "M-p") 'my/previous-line)
  (define-key eww-mode-map (kbd "M-n") 'my/next-line))

(provide 'config-eww)
