;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Settings (Non-Graphical)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-directory "~/org")

;; Show orgmode where agenda data is located
(setq org-agenda-files '("~/org/agenda"))

;; Record time when a todo is marked done
(setq org-log-done 'time)

;; Follow links
(setq org-return-follows-link t)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Preserve indentation in source blocks when pasting
(setq org-src-preserve-indentation t)
(setq org-edit-src-content-indentation 0)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; Close dedicated frames when closing org-capture
;; This is behavioral, not graphical, so it can run always.
(defun my-org-capture-delete-frame-hook ()
  "Delete the capture frame if it's not the last one."
  ;; This safety check ensures you don't accidentally
  ;; close your *main* Emacs window.
  (when (> (length (frame-list)) 1)
    (delete-frame)))

;; Run our function after capture is saved OR aborted
(add-hook 'org-capture-after-finalize-hook #'my-org-capture-delete-frame-hook)
(add-hook 'org-capture-aborted-hook #'my-org-capture-delete-frame-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Templates (Non-Graphical)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-capture-templates
      '(
	("g" "General To-Do"
	 entry (file+headline "~/org/agenda/inbox.org" "General Tasks")
	 "** TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n")

	("d" "Development To-Do"
	 entry (file+headline "~/org/agenda/inbox.org" "Development Related Tasks")
	 "** TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n")

	("D" "Discussion Note"
	 entry (file+headline "~/org/agenda/discussion-notes.org" "Discussions")
	 "** %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n*** "
	 :empty-lines 0)

	("c" "Code To-Do"
	 entry (file+headline "~/org/agenda/inbox.org" "Code Tasks")
	 "** TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END\n%i\n%a\nProposed Solution: "
	 :empty-lines 0)

	("n" "Note"
	 entry (file+headline "~/org/agenda/notes.org" "Notes")
	 "** %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n"
	 :empty-lines 0)

	("i" "Idea"
	 entry (file+headline "~/org/agenda/idea-factory.org" "Ideas")
	 "** %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n"
	 :empty-lines 0)

	("s" "Schedule Timeblock"
	 entry (file+headline "~/org/agenda/work.org" "Scheduling")
	 "** %?\n"
	 :empty-lines 0)

	("Q" "Question"
	 entry (file+headline "~/org/agenda/questions.org" "Questions")
	 "** %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n*** Context\n\n\n*** Why this matters\n\n"
	 :empty-lines 1)
	)
      )

(with-eval-after-load 'org-capture
  (add-to-list 'org-capture-templates
	       '("x" "New note (with Denote)" plain
		 (file denote-last-path)
		 #'denote-org-capture
		 :no-save t
		 :immediate-finish nil
		 :kill-buffer t
		 :jump-to-captured t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Refile settings (Non-Graphical)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configure org-refile to see all agenda files and their headlines
(setq org-refile-targets
      '(;; This now points to (setq org-agenda-files ...)
	(org-agenda-files :maxlevel . 3)))

(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Custom code to refile a subtree to a new user defined file
(defun my/org-refile-to-new-file ()
  "Move the current subtree to a new file. 
   Prompts for a filename and directory."
  (interactive)
  (let* ((subtree-content (org-get-entry)) ;; Get content
         (headline (nth 4 (org-heading-components))) ;; Get title for filename suggestion
         ;; specific formatting for the filename (slugify)
         (suggested-name (replace-regexp-in-string " " "-" (downcase headline)))
         (filename (read-file-name "New file name: " nil nil nil (concat suggested-name ".org"))))
    
    ;; 1. Cut the subtree from the current buffer
    (org-cut-subtree)
    
    ;; 2. Create/Open the new file
    (find-file filename)
    
    ;; 3. Paste the subtree
    (org-paste-subtree)
    
    ;; 4. Promote the subtree to top-level (optional, usually preferred for new files)
    (while (> (funcall outline-level) 1)
      (org-promote-subtree))
    
    ;; 5. Save the new file
    (save-buffer)
    
    (message "Refiled to %s" filename)))

;; Bind it to a key (e.g., C-c R)
(global-set-key (kbd "C-c r") 'my/org-refile-to-new-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Archive settings (Non-Graphical)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set the location for archived tasks
(setq org-archive-location "~/org/archive/archive.org::* From %s")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visual Settings (Refactored)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-bullets
  :ensure t
  :hook (org-mode . (lambda ()
                      (when (display-graphic-p)
                        (org-bullets-mode 1)))))

(defun my/setup-org-graphics ()
  "Apply graphical Org Mode faces."
  (let* ((base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit variable-pitch :weight bold :foreground ,base-font-color))
         (headline2          `(:inherit variable-pitch :weight semi-bold :foreground ,base-font-color)))
    
    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline2))))
     `(org-level-7 ((t (,@headline2))))
     `(org-level-6 ((t (,@headline2))))
     `(org-level-5 ((t (,@headline2))))
     `(org-level-4 ((t (,@headline2 :height 1.0))))
     `(org-level-3 ((t (,@headline2 :height 1.05))))
     `(org-level-2 ((t (,@headline2 :height 1.15))))
     `(org-level-1 ((t (,@headline :height 1.3))))
     `(org-document-title ((t (,@headline :height 1.0 :underline nil))))
      ;; Add org-table face configuration here
      `(org-table ((t (,@(if (find-font (font-spec :name "Aporetic Serif Mono"))
                             '(:font "Aporetic Serif Mono" :height 1.0 :inherit fixed-pitch)
                           '(:inherit fixed-pitch)))))))))

;; "Provide" this function to the custom hook
(add-hook 'my-graphical-setup-hook #'my/setup-org-graphics)


;; --- Function to set up graphical TODO faces ---
(defun my/setup-org-todo-faces ()
  "Apply graphical faces to TODO keywords."
  (setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "GoldenRod" :weight bold))
	("NEXT" . (:foreground "Cyan" :weight bold))
	("WAITING" . (:foreground "DarkOrange" :weight bold))
	("BLOCKED" . (:foreground "Red" :weight bold))
        ("DONE" . (:foreground "LimeGreen" :weight bold))
        ("WONT-DO" . (:foreground "LimeGreen" :weight bold))
        )))

;; "Provide" this function to the custom hook
(add-hook 'my-graphical-setup-hook #'my/setup-org-todo-faces)


(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "BLOCKED(b@/!)" "|" "WONT-DO(c@/!)")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings (Non-Graphical)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Shortcuts for storing links, viewing the agenda and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; Change the level of an org item
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c o r") 'org-metaright)
  (define-key org-mode-map (kbd "C-c o l") 'org-metaleft)
  (define-key org-mode-map (kbd "C-c o u") 'org-priority-up)
  (define-key org-mode-map (kbd "C-c o d") 'org-priority-down))



;; Use variable pitch font for Org body text
(add-hook 'org-mode-hook 'variable-pitch-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load additional org mode packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package compat
  :disabled t
  :ensure nil)

(use-package org-timeblock
  :disabled t
  :ensure nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Return the package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'config-orgmode)
