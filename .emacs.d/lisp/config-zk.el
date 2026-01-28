(use-package zk
  :ensure t
  :custom
  (zk-directory "~/OrgFiles/zk")
  (zk-file-extension "org")
  :config
  (setq zk-new-note-link-insert 'zk)
  (zk-setup-auto-link-buttons)
  (setq zk-file-name-separator "-")
  ;; use denote style ID format
  (setq zk-id-time-string-format "%Y%m%dT%H%M%S")
  ;; regex that matches YYYYMMDDTHHMMSS
  (setq zk-id-regexp "\\([0-9]\\{8\\}T[0-9]\\{6\\}\\)")
  ;; use org-mode tag format :tag: instead of #tag
  (setq zk-tag-regexp ":[a-zA-Z0-9_@]+:"))

;;------------------------------------------------------------------------------
;; Integrate with org mode
;;------------------------------------------------------------------------------
(defun zk-org-try-to-follow-link (fn &optional arg)
  "When 'org-open-at-point' FN fails, try 'zk-follow-link-at-point'.
Optional ARG."
  (let ((org-link-search-must-match-exact-headline t))
    (condition-case nil
	(apply fn arg)
      (error (zk-follow-link-at-point)))))

(advice-add 'org-open-at-point :around #'zk-org-try-to-follow-link)

;;------------------------------------------------------------------------------
;; Custom header function with denote-style front matter
;;------------------------------------------------------------------------------
(defun zk-denote-style-header (title new-id &optional orig-id)
  "Insert denote-style front matter for new notes with TITLE and NEW-ID.
Optionally use ORIG-ID for backlink insertion in zk style."
  ;; Insert denote-style org front matter
  (insert (format "#+title:      %s\n" title))
  (insert (format "#+date:       %s\n" (format-time-string "[%Y-%m-%d %a %H:%M]")))
  (insert "#+filetags:   \n")
  (insert (format "#+identifier: %s\n" new-id))
  (insert "\n")
  ;; Add zk-style backlink section if orig-id exists
  (when (ignore-errors (zk--parse-id 'title orig-id)) ;; check for file
    (insert "===\n<- ")
    (zk--insert-link-and-title orig-id)
    (newline)
    (insert "===\n\n")))

;; Set the custom header function
(setq zk-new-note-header-function #'zk-denote-style-header)

(provide 'config-zk)
