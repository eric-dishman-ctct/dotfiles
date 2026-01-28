;;; package --- config-treesitter.el --- Tree-sitter configuration for enhanced syntax highlighting  -*- lexical-binding: t; -*-

;;; Commentary:
;; This file configures tree-sitter for enhanced syntax highlighting and AST viewing.
;; Tree-sitter provides fast, incremental parsing for better code understanding.

;;; Code:

;;----------------------------------------------------------------------------
;; Tree-sitter Core
;;----------------------------------------------------------------------------
(add-to-list 'display-buffer-alist
	     '("^*tree-sitter explorer *" display-buffer-in-side-window
	       (side . right)
	       (window-width . 0.40)))

(setq treesit-font-lock-level 4)

;;----------------------------------------------------------------------------
;; Fixes and Workarounds
;;----------------------------------------------------------------------------
;; (with-eval-after-load 'c-ts-mode
;;   (require 'tree-sitter-query-fixes)
;;   (add-hook 'c-ts-mode-hook #'my-fix-c-ts-mode-queries))

;; Ensure c++-ts-mode also gets the fixes if needed
;; (with-eval-after-load 'c++-ts-mode
;;   (require 'tree-sitter-query-fixes)
;;   ;; You may want to create a similar function for C++ if needed
;;   ;; (add-hook 'c++-ts-mode-hook #'my-fix-cpp-ts-mode-queries)
;;   )

;;----------------------------------------------------------------------------
;; Tree-sitter Language Grammars
;;----------------------------------------------------------------------------
(defvar treesit-language-source-alist)

;; (setq treesit-language-source-alist
;;       '((matlab "https://github.com/acristoffers/tree-sitter-matlab")))

;; (dolist (lang (mapcar #'car treesit-language-source-alist))
;;   (unless (treesit-language-available-p lang)
;;     (treesit-install-language-grammar lang)))


(setq major-mode-remap-alist
      '((matlab-mode . matlab-ts-mode)))

;;------------------------------------------------------------------------------
;; Tree-sitter Folding
;;------------------------------------------------------------------------------
(use-package treesit-fold
  :load-path "~/source/treesit-fold"
  :config
  ;; Custom fold range function for MATLAB using tree-sitter node structure
  (defun my-treesit-fold-range-matlab-block (node offset)
    "Fold range for MATLAB blocks using tree-sitter structure.
Folds the body content, preserving the signature line and 'end' keyword.
For arguments NODE and OFFSET, see `treesit-fold-range-seq'."
    (let* ((children (treesit-node-children node))
           (block-node nil)
           beg end)
      ;; Find the 'block' child node
      (dolist (child children)
        (when (equal (treesit-node-type child) "block")
          (setq block-node child)))
      
      (if block-node
          ;; If there's a block node, fold just its contents
          (let ((block-start (treesit-node-start block-node))
                (block-end (treesit-node-end block-node)))
            ;; Start after the first line (function/for/if signature)
            (setq beg (save-excursion
                        (goto-char (treesit-node-start node))
                        (end-of-line)
                        (point)))
            ;; End before the 'end' keyword (at end of block)
            (setq end (save-excursion
                        (goto-char block-end)
                        (skip-chars-backward " \t\n")
                        (point))))
        ;; Fallback for nodes without explicit block child
        (setq beg (save-excursion
                    (goto-char (treesit-node-start node))
                    (end-of-line)
                    (point)))
        (setq end (save-excursion
                    (goto-char (treesit-node-end node))
                    (beginning-of-line)
                    (skip-chars-backward " \t\n")
                    (point))))
      
      (when (and beg end (< beg end))
        (treesit-fold--cons-add (cons beg end) offset))))
  
  ;; Custom MATLAB parser for matlab-ts-mode
  (defun my-treesit-fold-parsers-matlab ()
    "Custom fold parser for MATLAB with proper block folding."
    '((function_definition . my-treesit-fold-range-matlab-block)
      (if_statement . my-treesit-fold-range-matlab-block)
      (for_statement . my-treesit-fold-range-matlab-block)
      (while_statement . my-treesit-fold-range-matlab-block)
      (switch_statement . my-treesit-fold-range-matlab-block)
      (try_statement . my-treesit-fold-range-matlab-block)
      (comment . treesit-fold-range-seq)))
  
  ;; Add matlab-ts-mode support with our custom parser
  (add-to-list 'treesit-fold-range-alist
               (cons 'matlab-ts-mode (my-treesit-fold-parsers-matlab)))
  
  ;; Enable treesit-fold-mode in tree-sitter modes
  (add-hook 'python-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'c-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'matlab-ts-mode-hook #'treesit-fold-mode)

  ;; Define key bindings within the use-package
  (define-key treesit-fold-mode-map (kbd "C-c t f") #'treesit-fold-toggle)
  (define-key treesit-fold-mode-map (kbd "C-c t o") #'treesit-fold-open-all)
  (define-key treesit-fold-mode-map (kbd "C-c t c") #'treesit-fold-close-all)
  (define-key treesit-fold-mode-map (kbd "C-c t r") #'treesit-fold-open-recursively)

  ;; Custom functions for hierarchical folding
  (defun my/treesit-fold-all-defuns ()
    "Fold all function and method definitions in the buffer."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let ((node-types '("function_definition" "method_definition" "function_declaration")))
        (while (not (eobp))
          (let* ((node (treesit-node-at (point)))
                 (parent (treesit-node-parent node)))
            (when (and parent (member (treesit-node-type parent) node-types))
              (goto-char (treesit-node-start parent))
              (treesit-fold-close parent)
              (goto-char (treesit-node-end parent))))
          (forward-line 1)))))

  (defun my/treesit-fold-all-classes ()
    "Fold all class definitions in the buffer."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (let* ((node (treesit-node-at (point)))
               (parent (treesit-node-parent node)))
          (when (and parent (equal (treesit-node-type parent) "class_definition"))
            (goto-char (treesit-node-start parent))
            (treesit-fold-close parent)
            (goto-char (treesit-node-end parent))))
        (forward-line 1))))

  (defun my/treesit-fold-all-blocks ()
    "Fold all blocks (if/for/while/try) in the buffer."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let ((node-types '("if_statement" "for_statement" "while_statement"
                          "try_statement" "with_statement")))
        (while (not (eobp))
          (let* ((node (treesit-node-at (point)))
                 (parent (treesit-node-parent node)))
            (when (and parent (member (treesit-node-type parent) node-types))
              (goto-char (treesit-node-start parent))
              (treesit-fold-close parent)
              (goto-char (treesit-node-end parent))))
          (forward-line 1)))))

  (defun my/treesit-fold-level (level)
    "Fold all nodes at tree depth LEVEL.
LEVEL 1 folds top-level definitions, 2 folds their children, etc."
    (interactive "nFold level (1-9): ")
    (treesit-fold-open-all)  ; First open everything
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (let* ((node (treesit-node-at (point)))
               (depth 0)
               (current node))
          ;; Calculate depth
          (while (setq current (treesit-node-parent current))
            (setq depth (1+ depth)))
          ;; Fold if at or deeper than target level
          (when (and (>= depth level)
                     (treesit-fold--foldable-node-at-pos (point)))
            (treesit-fold-close node)))
        (forward-line 1))))

  (defun my/treesit-fold-open-recursively-dwim ()
    "Smart recursive fold opening.
Finds the nearest containing foldable node (class, function, etc.) and opens
it recursively. Works whether cursor is on the signature, inside the fold,
or anywhere within the node."
    (interactive)
    (let* ((node (treesit-node-at (point)))
           (containing-node node)
           (fold-types '("function_definition" "class_definition" "method_definition"
                        "if_statement" "for_statement" "while_statement"
                        "try_statement" "with_statement"))
           (found-node nil)
           (overlays (overlays-at (point))))

      ;; First check if we're inside a folded overlay
      (dolist (ov overlays)
        (when (eq (overlay-get ov 'invisible) 'treesit-fold)
          ;; Move to the start of the fold
          (goto-char (overlay-start ov))
          (setq node (treesit-node-at (point)))
          (setq containing-node node)))

      ;; Walk up the tree to find a foldable parent node
      (while (and containing-node (not found-node))
        (when (member (treesit-node-type containing-node) fold-types)
          (setq found-node containing-node))
        (setq containing-node (treesit-node-parent containing-node)))

      ;; If we found a foldable node, go to its start and open recursively
      (if found-node
          (progn
            (goto-char (treesit-node-start found-node))
            (treesit-fold-open)  ; Make sure it's open first
            (treesit-fold-open-recursively)
            (message "Opened %s recursively" (treesit-node-type found-node)))
        ;; Otherwise just do regular open-recursively
        (treesit-fold-open-recursively)
        (message "Opened folds recursively"))))

  ;; Additional hierarchical folding key bindings
  (define-key treesit-fold-mode-map (kbd "C-c t d") #'my/treesit-fold-all-defuns)
  (define-key treesit-fold-mode-map (kbd "C-c t C") #'my/treesit-fold-all-classes)
  (define-key treesit-fold-mode-map (kbd "C-c t b") #'my/treesit-fold-all-blocks)
  (define-key treesit-fold-mode-map (kbd "C-c t l") #'my/treesit-fold-level))

(provide 'config-treesitter)

;;; config-treesitter.el ends here
