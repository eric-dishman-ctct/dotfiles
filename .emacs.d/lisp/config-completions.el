;;; package --- config-compl.el  Completion Suite  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Vertical completion UI
(use-package vertico
  :init
  (vertico-mode)
  :config
  (set-face-attribute 'vertico-current nil
		      :underline nil
		      :background "#404040"))

;; Fuzzy matching for vertico
(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

;; Annotations in minibuffer
(use-package marginalia
  :init
  (marginalia-mode))

;; Enhanced commands
(use-package consult
  :bind (("C-s" . consult-line)      ; Better search
	 ("C-x b" . consult-buffer)  ; Better buffer switching
	 ("C-c i" . consult-imenu)   ; Better imenu
	 ("M-y" . consult-yank-pop)  ; Better kill-ring
	 ("C-c g" . consult-grep)    ; Grep in project
	 ("C-c f" . consult-find)))  ; Better find files

;; Completion popup
(use-package corfu
  :init
  (global-corfu-mode)
  :config
  (setq corfug-auto nil) ; Maunual trigger with C-M-i
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (define-key corfu-map (kbd "TAB") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

(provide 'config-completions)
