;; MATLAB
(add-to-list 'load-path "/home/u_dishmej/.emacs.d/packages/Emacs-MATLAB-Mode")

(let ((matlab-bin "/home/u_dishmej/opt/MATLAB/R2024B/bin/matlab"))
  (when (file-exists-p matlab-bin)
    (setq matlab-shell-command matlab-bin)))

(when (locate-library "matlab-ts-mode")
  (require 'matlab-ts-mode))

(when (locate-library "matlab-shell")
  (require 'matlab-shell))

;; Set tab sizes and types
(add-hook 'matlab-ts-mode-hook
          (lambda ()
            (setq tab-width 4)
            (setq matlab-indent-level 4)
            (setq indent-tabs-mode nil)  ; Use spaces instead of tabs
            ;; Don't add newline at end of file (for Windows compatibility)
            (setq require-final-newline nil)
            (setq mode-require-final-newline nil)))

;; Teach Copilot about MATLAB indentation
(with-eval-after-load 'copilot
  (add-to-list 'copilot-indentation-alist '(matlab-mode . matlab-indent-level))
  (add-to-list 'copilot-indentation-alist '(matlab-ts-mode . matlab-indent-level))
  (set-face-attribute 'matlab-sections-highlight-face nil :weight 'bold))

(provide 'config-matlab)
