;;; package --- config-copilot.el  GitHub Copilot Configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; This file configures two complementary GitHub Copilot packages:
;; - copilot.el: Inline code completions (ghost text as you type)
;; - copilot-chat.el: Conversational AI chat interface

;;; Code:

;; ============================================================================
;; copilot.el - Inline AI Code Completions
;; ============================================================================
;; This provides VS Code-style ghost text completions as you type.
;; It works alongside Corfu - Corfu handles LSP/symbol completions,
;; while Copilot provides AI-powered line/block suggestions.
;;
;; NOTE: copilot.el is not on MELPA. You must install it manually:
;;   1. Clone: git clone https://github.com/copilot-emacs/copilot.el ~/.emacs.d/copilot
;;   2. Then this config will load it from there.
;;
;; After loading, run: M-x copilot-install-server
;;                     M-x copilot-login

(use-package copilot
  :load-path "~/.emacs.d/copilot"  ; Manual install location
  :ensure nil                       ; Don't try to install from MELPA
  :hook (prog-mode . copilot-mode)  ; Enable in all programming modes
  :bind (:map copilot-completion-map
              ;; Accept full completion with TAB
              ("<tab>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ;; Partial acceptance
              ("C-<tab>" . copilot-accept-completion-by-word)
              ("M-<tab>" . copilot-accept-completion-by-line)
              ;; Cycle through suggestions
              ("M-n" . copilot-next-completion)
              ("M-p" . copilot-previous-completion))
              ;; Dismiss with C-g (default)
  :config
  ;; Wait a moment before showing suggestions (reduces noise)
  (setq copilot-idle-delay 0.3)
  
  ;; Configure LSP settings for the language server
  (setq copilot-lsp-settings
        '(:copilot
          (:encodingMode "auto")))
  
  ;; Disable copilot in certain situations
  (add-to-list 'copilot-disable-predicates
               (lambda () (bound-and-true-p company-candidates)))  ; If company is active
  (add-to-list 'copilot-disable-predicates
               (lambda () (and (boundp 'corfu--frame) corfu--frame))))  ; If corfu popup is visible


;; ============================================================================
;; copilot-chat.el - Conversational AI Interface
;; ============================================================================
;; This provides a chat interface for longer interactions:
;; - Explain code, review code, fix bugs, generate tests, etc.
;; - Uses selected region or buffer as context

;; Define a prefix key for copilot-chat commands
(define-prefix-command 'copilot-chat-prefix-map)
(global-set-key (kbd "C-c a") 'copilot-chat-prefix-map)

(use-package copilot-chat
  :ensure t
  :bind (;; Yank from chat
         ("C-c C-y" . copilot-chat-yank)
         ("C-c M-y" . copilot-chat-yank-pop)
         ;; Quick access to common prompts (under C-c a prefix)
         :map copilot-chat-prefix-map
         ("t" . copilot-chat-transient)      ; Transient menu (main entry point)
         ("e" . copilot-chat-explain)        ; Explain selected code
         ("r" . copilot-chat-review)         ; Review selected code
         ("f" . copilot-chat-fix)            ; Fix selected code
         ("d" . copilot-chat-doc)            ; Generate documentation
         ("o" . copilot-chat-optimize)       ; Optimize selected code
         ("u" . copilot-chat-test)           ; Generate unit tests
         ("c" . copilot-chat-commit)         ; Generate commit message
         ("a" . copilot-chat-ask-and-insert)); Ask and insert at point
  :config
  (setq copilot-chat-default-model "claude-sonnet-4.5")
  (define-key polymode-minor-mode-map (kbd "M-n") nil)
  (define-key polymode-minor-mode-map (kbd "C-c p") polymode-map))

(provide 'config-copilot)
