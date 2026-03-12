;;; package --- config-ui.el  User Interface  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; --- Non-Graphical Settings (run immediately) ---
(setq ring-bell-function 'ignore)
(setq-default truncate-lines t)
(setq inhibit-startup-screen t)

;; Better scrolling behavior
(setq scroll-conservatively 101)
(setq scroll-margin 4)

;; Set a transparent window
;;(add-to-list 'default-frame-alist '(alpha . 90))
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes/" user-emacs-directory))
;;------------------------------------------------------------------------------
;; Imperative Graphical Settings
;;------------------------------------------------------------------------------
(defun my-setup-ui-graphics ()
  "Apply graphical UI settings like fonts, themes, and faces."

  (tool-bar-mode -1)
  (menu-bar-mode -1)

  ;; --- Font Configuration ---
  ;; 1. Set the default (fixed-pitch font) for ALL code, org-blocks, and shells
  (when (find-font (font-spec :name "JetBrainsMono Nerd Font"))
    (set-face-attribute 'default nil
                        :font "JetBrainsMono Nerd Font"
                        ;; Set height relative to the default face's height
                        ;; This keeps code and text balanced.
                        :height (if (boundp 'my/default-font-height)
                                    my/default-font-height
                                  140)))
  
  ;; 2. Set the (variable-pitch) font for UI and Org text
  (when (find-font (font-spec :name "Aporetic Serif"))
    (set-face-attribute 'variable-pitch nil
                        :font "Aporetic Serif"
                        :weight 'regular
                        :height 1.0))

  ;; 3. Set fixed-pitch explicitly (good practice)
  (when (find-font (font-spec :name "JetBrainsMono Nerd Font"))
    (set-face-attribute 'fixed-pitch nil
                        :font "JetBrainsMono Nerd Font"
                        :height 1.0))

  ;; 4. Set org-table face to use monospaced Aporetic font
  (when (find-font (font-spec :name "Aporetic Serif Mono"))
    (set-face-attribute 'org-table nil
                        :font "Aporetic Serif Mono"
                        :height 1.0
                        :inherit nil))

  ;; --- End Font Configuration ---

  ;; Custom faces for rainbow-delimiters
  ;; (custom-set-faces
  ;;  '(rainbow-delimiters-depth-1-face ((t (:foreground "#8BE9FD"))))
  ;;  '(rainbow-delimiters-depth-2-face ((t (:foreground "#50FA7B"))))
  ;;  '(rainbow-delimiters-depth-3-face ((t (:foreground "#FFB86C"))))
  ;;  '(rainbow-delimiters-depth-4-face ((t (:foreground "#FF79C6"))))
  ;;  '(rainbow-delimiters-depth-5-face ((t (:foreground "#BD93F9"))))
  ;;  '(rainbow-delimiters-depth-6-face ((t (:foreground "#FF5555"))))
  ;;  '(rainbow-delimiters-depth-7-face ((t (:foreground "#F1FA8C"))))
  ;;  '(rainbow-delimiters-depth-8-face ((t (:foreground "#6272A4"))))
  ;;  '(rainbow-delimiters-depth-9-face ((t (:foreground "#E6E6E6")))))

  ;; Enable doom-modeline imperatively
  ;;  (doom-modeline-mode 1))
  )


;; --- "Provide" our function to the custom hook ---
;; (my-graphical-setup-hook is defined in init.el)
(add-hook 'my-graphical-setup-hook #'my-setup-ui-graphics)

;;------------------------------------------------------------------------------
;; Graphical Packages (Declarative)
;;------------------------------------------------------------------------------

(use-package display-line-numbers
  :ensure nil
  :hook
  (prog-mode . display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'relative))

(use-package nerd-icons
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  :custom-face
  (rainbow-delimiters-depth-1-face ((t (:foreground "#8BE9FD"))))
  (rainbow-delimiters-depth-2-face ((t (:foreground "#50FA7B"))))
  (rainbow-delimiters-depth-3-face ((t (:foreground "#FFB86C"))))
  (rainbow-delimiters-depth-4-face ((t (:foreground "#FF79C6"))))
  (rainbow-delimiters-depth-5-face ((t (:foreground "#BD93F9"))))
  (rainbow-delimiters-depth-6-face ((t (:foreground "#FF5555"))))
  (rainbow-delimiters-depth-7-face ((t (:foreground "#F1FA8C"))))
  (rainbow-delimiters-depth-8-face ((t (:foreground "#6272A4"))))
  (rainbow-delimiters-depth-9-face ((t (:foreground "#E6E6E6")))))


(use-package keycast
  :ensure t)

(use-package switch-window
  :ensure t
  :bind
  ( :map global-map
    ("C-x o" . switch-window))
  :custom
  (switch-window-shortcut-style 'qwerty))

; (global-set-key (kbd "C-x o") 'switch-window)
;;------------------------------------------------------------------------------
;; Status Line
;;------------------------------------------------------------------------------
;; (use-package doom-modeline
;;   :ensure t)

;; (with-eval-after-load 'which-func
;;   (set-face-attribute 'which-func nil
;; 		      :inherit 'doom-modeline-buffer-file
;; 		      :forground nil)) ; use doom-modeline's colors

(use-package mixed-pitch
  :ensure t
  :hook
  (org-mode . mixed-pitch-mode)
  :custom
  ;; Ensure org-mode structural elements stay fixed-pitch
  (mixed-pitch-set-height t)
  :config
  (when (find-font (font-spec :name "Aporetic Serif Mono"))
    (set-face-attribute 'org-table nil
                        :font "Aporetic Serif Mono"
                        :height 1.0
                        :inherit nil)))


;;------------------------------------------------------------------------------
;; Reading Mode Configuration
;;------------------------------------------------------------------------------
(use-package olivetti
  :ensure t
  :commands olivetti-mode
  :custom
  (olivetti-body-width 100)
  (olivetti-style nil))

(defun my/reading-mode()
  "Toggle reading mode for distraction-free reading of org and markdown files."
  (interactive)
  (if olivetti-mode
      (progn
	(olivetti-mode -1)
	(display-line-numbers-mode 1)
	(message "Reading mode disabled"))
    (progn
      (olivetti-mode 1)
      (display-line-numbers-mode -1)
      (message "Reading mode enabled"))))

;; Automatically enable reading mode for org and markdown files
(defun my/maybe-enable-reading-mode()
  "Automatically enable reading mode for org and markdown files"
  (when (or (derived-mode-p 'org-mode)
	    (derived-mode-p 'markdown-mode)
	    (derived-mode-p 'gfm-mode))
    (olivetti-mode 1)
    (display-line-numbers-mode -1)))

;; Hook for automatic reading mode
(add-hook 'find-file-hook 'my/maybe-enable-reading-mode)

(global-set-key (kbd "C-c R") 'my/reading-mode)

;;------------------------------------------------------------------------------
;; XREF Buffer
;;------------------------------------------------------------------------------
(add-to-list 'display-buffer-alist
	     '("\\*xref\\*"
	       (display-buffer-in-side-window)
	       (side . bottom)
	       (window-height . 0.2)))

;;------------------------------------------------------------------------------
;; Flymake diagnostics
;;------------------------------------------------------------------------------
(add-to-list 'display-buffer-alist
	     '("\\*Flymake diagnostics.*\\*"
	       (display-buffer-in-side-window)
	       (side . bottom)
	       (window-height . 0.2)))
;;------------------------------------------------------------------------------
;; Dired
;;------------------------------------------------------------------------------
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;;------------------------------------------------------------------------------
;; Region Font Customization
;;------------------------------------------------------------------------------

(defun my/set-region-variable-pitch ()
  "Set selected region to variable-pitch font (Aporetic Serif with normal text color)."
  (interactive)
  (if (use-region-p)
      (let ((ov (make-overlay (region-beginning) (region-end) nil nil nil)))
        (overlay-put ov 'face '(:inherit variable-pitch))
        (overlay-put ov 'my-custom-font t)
        (message "Applied variable-pitch (Aporetic Serif) to region"))
    (message "No active region")))

(defun my/set-region-fixed-pitch ()
  "Set selected region to fixed-pitch font (JetBrains Mono) with code block styling."
  (interactive)
  (if (use-region-p)
      (let ((ov (make-overlay (region-beginning) (region-end) nil nil nil)))
        ;; Inherit from org-code which already has the right styling
        (overlay-put ov 'face '(:inherit org-code))
        (overlay-put ov 'my-custom-font t)
        (message "Applied fixed-pitch (JetBrains Mono) with code styling to region"))
    (message "No active region")))

(defun my/set-region-org-table ()
  "Set selected region to org-table font (Aporetic Serif Mono with normal text color)."
  (interactive)
  (if (use-region-p)
      (let ((ov (make-overlay (region-beginning) (region-end) nil nil nil)))
        (overlay-put ov 'face '(:inherit org-table))
        (overlay-put ov 'my-custom-font t)
        (message "Applied org-table (Aporetic Serif Mono) to region"))
    (message "No active region")))

(defun my/remove-region-font ()
  "Remove custom font overlays from the selected region or at point."
  (interactive)
  (let* ((start (if (use-region-p) (region-beginning) (point)))
         (end (if (use-region-p) (region-end) (point)))
         (removed 0))
    ;; Remove overlays that overlap with the region/point
    (dolist (ov (overlays-in start end))
      (when (overlay-get ov 'my-custom-font)
        (delete-overlay ov)
        (setq removed (1+ removed))))
    ;; Also check overlays at the exact point
    (dolist (ov (overlays-at (point)))
      (when (overlay-get ov 'my-custom-font)
        (delete-overlay ov)
        (setq removed (1+ removed))))
    (message "Removed %d font overlay(s)" removed)))

(defun my/remove-tildes-around-region ()
  "Remove concealed tildes (~) on either side of the selected region.
If no region is active, search forward from point for matching tildes."
  (interactive)
  (if (use-region-p)
      ;; Original region-based behavior
      (let* ((start (region-beginning))
             (end (region-end))
             (before-char (when (> start (point-min))
                           (char-after start)))
             (after-char (when (< end (point-max))
                          (char-after end)))
             (removed-count 0))
        
        ;; Delete from back to front to preserve positions
        (save-excursion
          ;; Remove trailing tilde
          (when (and after-char (eq after-char ?~))
            (goto-char end)
            (delete-char 1)
            (setq removed-count (1+ removed-count)))
          
          ;; Remove leading tilde
          (when (and before-char (eq before-char ?~))
            (goto-char start)
            (delete-char 1)
            (setq removed-count (1+ removed-count))))
        
        (if (> removed-count 0)
            (message "Removed %d tilde(s) around region" removed-count)
          (message "No tildes found around region")))
    
    ;; New behavior: cursor at tilde, search forward for matching tilde
    (let ((start-pos (point)))
      (if (eq (char-after start-pos) ?~)
          (save-excursion
            (let ((end-tilde-pos (save-excursion
                                   (forward-char 1)
                                   (search-forward "~" nil t))))
              (if end-tilde-pos
                  (progn
                    ;; Delete from back to front to preserve positions
                    (goto-char end-tilde-pos)
                    (delete-char -1)
                    (goto-char start-pos)
                    (delete-char 1)
                    (message "Removed tildes at positions %d and %d" 
                             start-pos (1- end-tilde-pos)))
                (message "No matching closing tilde found"))))
        (message "Cursor is not at a tilde (~)")))))

;; Convenient keybindings
;; (global-set-key (kbd "C-c f v") 'my/set-region-variable-pitch)
;; (global-set-key (kbd "C-c f c") 'my/set-region-fixed-pitch)
;; (global-set-key (kbd "C-c f t") 'my/set-region-org-table)
;; (global-set-key (kbd "C-c f r") 'my/remove-region-font)


(provide 'config-ui)
