;;; package --- config-compl.el  Completion Suite  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Vertical completion UI
(use-package vertico
  :ensure t
  :custom
  (vertico-mode t)
  :custom-face
  (vertico-current ((t (:underline nil :background "#404040")))))

;; Fuzzy matching for vertico
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

;; Annotations in minibuffer
(use-package marginalia
  :ensure t
  :custom
  (marginalia-mode t))

;; Enhanced commands
(use-package consult
  :ensure t
  :bind (:map global-map
	      ("C-s" . consult-line)      ; Better search
	      ("C-x b" . consult-buffer)  ; Better buffer switching
	      ("C-c i" . consult-imenu)   ; Better imenu
	      ("M-y" . consult-yank-pop)  ; Better kill-ring
	      ("C-c g" . consult-grep)    ; Grep in project
	      ("C-c f" . consult-find)))  ; Better find files

;; Completion popup
(use-package corfu
  :ensure t
  :custom
  (global-corfu-mode t)
  (corfu-auto nil) ; Maunual trigger with C-M-i
  :bind (:map corfu-map
	      ("C-n" . corfu-next)
	      ("C-p" . corfu-previous)
	      ("TAB" . corfu-insert)
	      ("RET" . corfu-insert)))

(provide 'config-completions)
