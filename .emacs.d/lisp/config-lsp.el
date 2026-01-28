(use-package eglot
  :ensure nil
  :config
  ;; 1. Add MATLAB bin to the Emacs executable path
  (add-to-list 'exec-path "/home/u_dishmej/opt/MATLAB/R2024b/bin")

  ;; 2. Add MATLAB bin to the environment PATH so Node.js can inherit it
  (setenv "PATH" (concat (getenv "PATH") ":/home/u_dishmej/opt/MATLAB/R2024b/bin"))

  ;; 3. Configure the server (Using 'cons' and 'list' to avoid syntax errors)
  (add-to-list 'eglot-server-programs
               (cons 'matlab-ts-mode 
                     (list "node"
                           (expand-file-name "~/opt/matlabls/out/index.js")
                           "--stdio"
                           "--matlabInstallPath"
                           (expand-file-name "~/opt/MATLAB/R2024b")))))

(add-hook 'matlab-ts-mode-hook 'eglot-ensure)

(provide 'config-lsp)
