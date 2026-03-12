(use-package eglot
  :ensure nil
  :config
  (let* ((matlab-bin "/home/u_dishmej/opt/MATLAB/R2024B/bin")
         (matlab-root (expand-file-name "~/opt/MATLAB/R2024B"))
         (matlab-ls (expand-file-name "~/opt/MATLAB/MATLAB-language-server/out/index.js")))
    (when (file-directory-p matlab-bin)
      ;; 1. Add MATLAB bin to the Emacs executable path
      (add-to-list 'exec-path matlab-bin)
      ;; 2. Add MATLAB bin to the environment PATH so Node.js can inherit it
      (setenv "PATH" (concat (getenv "PATH") ":" matlab-bin)))

    ;; 3. Configure MATLAB language server only when install paths are present
    (when (and (file-exists-p matlab-ls)
               (file-directory-p matlab-root))
      (add-to-list 'eglot-server-programs
                   (cons 'matlab-ts-mode
                         (list "node"
                               matlab-ls
                               "--stdio"
                               "--matlabInstallPath"
                               matlab-root))))))

(add-hook 'matlab-ts-mode-hook 'eglot-ensure)

(provide 'config-lsp)
