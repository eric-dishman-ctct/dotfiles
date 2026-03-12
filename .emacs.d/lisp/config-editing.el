;;; package --- config-editing.el Editing settings  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
;; Line ending configuration
;; Preserve original line endings when opening files, don't auto-convert
(setq-default buffer-file-coding-system 'undecided-unix)
;; Don't prompt about line endings
(setq inhibit-eol-conversion t)
;; When creating new files, use Unix line endings
(prefer-coding-system 'utf-8-unix)

;; Hide ^M (carriage return) characters visually without removing them
(defun hide-carriage-returns ()
  "Hide ^M characters in the buffer without removing them."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;; Show ^M characters again if hidden
(defun show-carriage-returns ()
  "Show ^M characters in the buffer."
  (interactive)
  (setq buffer-display-table nil))

;; Automatically hide ^M in all files
(add-hook 'find-file-hook #'hide-carriage-returns)

;; Convert to Unix line endings only when explicitly saving
(add-hook 'before-save-hook
          (lambda ()
            (when (and buffer-file-name
                       (not (eq buffer-file-coding-system 'utf-8-unix)))
              (set-buffer-file-coding-system 'utf-8-unix))))

;; Backup and autosave configuration
;; Store backup files in a central location instead of alongside original files
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))))
;; Store autosave files in a central location
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))
;; Create auto-save directory if it doesn't exist
(make-directory (expand-file-name "auto-saves/" user-emacs-directory) t)
;; Don't create lockfiles (the .# files)
(setq create-lockfiles nil)

;; Use M-p, M-n to "scroll" (actually, move lines)
(defun my/next-line ()
  "Provide better navigation by moving down 10 lines at a time, recentering each time."
  (interactive)
  (forward-line 10)
  (recenter))
(defun my/previous-line ()
  "Provide better navigation by moving up 10 lines at a time, recentering each time."
  (interactive)
  (forward-line -10)
  (recenter))
(if (fboundp 'keymap-global-set)
    (progn
      (keymap-global-set "M-p" #'my/previous-line)
      (keymap-global-set "M-n" #'my/next-line))
  (global-set-key (kbd "M-p") #'my/previous-line)
  (global-set-key (kbd "M-n") #'my/next-line))

;; Custom scroll other window
(defun my/scroll-other-window-down ()
  "Scroll the other window down by 10 lines."
  (interactive)
  (scroll-other-window '-10))
(defun my/scroll-other-window-up ()
  "Scroll the other window up by 10 lines."
  (interactive)
  (scroll-other-window '10))

;; Keybindings for scrolling other window
(if (fboundp 'keymap-global-set)
    (progn
      (keymap-global-set "C-M-v" #'my/scroll-other-window-up)
      (keymap-global-set "C-M-S-v" #'my/scroll-other-window-down))
  (global-set-key (kbd "C-M-v") #'my/scroll-other-window-up)
  (global-set-key (kbd "C-M-S-v") #'my/scroll-other-window-down))
  
;;; --- Modern Commenting Style ---
;; Use the 'indent' style, which creates ';;' at the start of lines.
(setq-default comment-style 'indent)

;; Stop forcing single-line comments to the end of the line.
(setq-default comment-column 0)

;; Sentences end with single space
(setq sentence-end-double-space nil)

;;; --- Dired Configuration ---
;; Enable dired-find-alternate-file (disabled by default)
(put 'dired-find-alternate-file 'disabled nil)

;; Configure Dired keybindings
(with-eval-after-load 'dired
  ;; 'a' uses the built-in alternate file function
  (define-key dired-mode-map (kbd "a") 'dired-find-alternate-file)
  ;; 'RET' works normally (opens new buffer)
  (define-key dired-mode-map (kbd "RET") 'dired-find-file)
  ;; '^' goes up directory and reuses buffer
  (define-key dired-mode-map (kbd "^")
	      (lambda () (interactive) (find-alternate-file ".."))))

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "M-p") 'my/previous-line)
  (define-key markdown-mode-map (kbd "M-n") 'my/next-line))

(use-package sudo-edit
  :ensure t
  )

(provide 'config-editing)
