;; MATLAB
;; (use-package matlab-mode
;;   :ensure t)

;; (use-package matlab-ts-mode
;;   :ensure nil)

(add-to-list 'load-path "/home/u_dishmej/source/Emacs-MATLAB-Mode")

(setq matlab-shell-command "/home/u_dishmej/opt/MATLAB/R2024b/bin/matlab")

(require 'matlab-ts-mode)
(require 'matlab-shell)

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
