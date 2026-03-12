;;; package --- My init.el  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; --- Define custom hook for all graphical setup ---
(defvar vader/graphical-setup-hook nil
  "A custom hook for functions to run *after* a graphical frame is created.
This is used to (re)apply graphical settings like fonts and colors that are skipped when running in daemon mode.")

(require 'config-packages)
(require 'config-treesitter)
(require 'config-custom-functions)
(require 'config-ui)
(require 'config-bindings)
(require 'config-editing)
(require 'config-completions)
(require 'config-orgmode)
(require 'config-lsp)
;; (require 'config-copilot)
(require 'config-eca)
(require 'config-matlab)
;; (require 'config-eww)
(require 'config-bibliography)
(require 'config-denote)
;; (require 'config-zk)
;; (require 'config-reader)

;; --- Master function to run all graphical setup ---
;; This is the *only* function attache to the real Emacs hook.
(defun vader/run-all-graphical-setup-hooks (frame)
  "Run all functions in 'vader/graphical-setup-hook' on FRAME."
  (with-selected-frame frame
    (when (display-graphic-p)
      (load-theme 'github-dark-dimmed t)
      ;; This runs all the functions we added, e.g.:
      ;; - vader/setup-ui-graphics
      ;; - vader/setup-org-graphics
      (run-hooks 'vader/graphical-setup-hook))))

;; --- Attach the master function to Emacs ---
(add-hook 'after-make-frame-functions #'vader/run-all-graphical-setup-hooks)

;; --- Manually run for the *initial* graphical frame ---
(when (display-graphic-p)
  (vader/run-all-graphical-setup-hooks (selected-frame)))
