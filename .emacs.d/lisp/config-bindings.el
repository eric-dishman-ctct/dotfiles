(defun vader/global-set-key (key command)
  "Bind KEY to COMMAND globally with compatibility fallback."
  (if (fboundp 'keymap-global-set)
      (keymap-global-set key command)
    (global-set-key (kbd key) command)))

(defun vader/global-set-keys (&rest pairs)
  "Set multiple global key PAIRS.
Each element is (KEY . COMMAND), where KEY is passed to `kbd'."
  (dolist (pair pairs)
    (vader/global-set-key (car pair) (cdr pair))))

(vader/global-set-keys
 '("C-x C-m" . execute-extended-command)
 '("C-c C-m" . execute-extended-command)
 '("C-x C-k" . kill-region)
 '("C-c C-k" . kill-region))

(provide 'config-bindings)
