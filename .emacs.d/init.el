;;; package --- My init.el  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; --- Define custom hook for all graphical setup ---
(defvar my-graphical-setup-hook nil
  "A custom hook for functions to run *after* a graphical frame is created.
This is used to (re)apply graphical settings like fonts and colors that are skipped when running in daemon mode.")

(require 'config-packages)
(require 'config-treesitter)
(require 'config-ui)
(require 'config-bindings)
(require 'config-editing)
(require 'config-completions)
(require 'config-orgmode)
(require 'config-lsp)
(require 'config-copilot)
(require 'config-matlab)
(require 'config-eww)
(require 'config-denote)
(require 'config-zk)
(require 'config-reader)
(require 'config-custom-functions)

;; --- Master function to run all graphical setup ---
;; This is the *only* function attache to the real Emacs hook.
(defun my-run-all-graphical-setup-hooks (frame)
  "Run all functions in 'my-graphical-setup-hook' on FRAME."
  (with-selected-frame frame
    (when (display-graphic-p)
      (load-theme 'wombat t)
      ;; This runs all the functions we added, e.g.:
      ;; - my-setup-ui-graphics
      ;; - my-setup-org-graphics
      (run-hooks 'my-graphical-setup-hook))))

;; --- Attach the master function to Emacs ---
(add-hook 'after-make-frame-functions #'my-run-all-graphical-setup-hooks)

;; --- Manually run for the *initial* graphical frame ---
(when (display-graphic-p)
  (my-run-all-graphical-setup-hooks (selected-frame)))
