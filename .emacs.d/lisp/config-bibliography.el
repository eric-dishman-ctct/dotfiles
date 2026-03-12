(use-package citar
  :ensure t
  :custom
  (citar-bibliography (expand-file-name "~/ref/bibliography.bib"))
  (citar-library-paths '("~/pdfs"))
  (citar-notes-paths '("~/org"))
  :hook
  (LaTex-mode . citar-capf-setup)
  (org-mode . citar-capf-setup))

(use-package biblio
  :ensure t
  :bind (:map global-map
              ("C-c b l" . my/biblio-lookup-to-default-bib)
              :map biblio-selection-mode-map
              ("i" . my/biblio-selection-insert-append)
              ("I" . my/biblio-selection-insert-append-quit)))

;;------------------------------------------------------------------------------
;; Custom default bibliography file
;;------------------------------------------------------------------------------
(defvar my/biblio-default-bibfile
  (expand-file-name "~/ref/bibliography.bib")
  "Default BibTeX file for biblio inserts.")

(defun my/biblio--append-to-default-bibfile (bibtex _entry)
  (with-current-buffer (find-file-noselect my/biblio-default-bibfile)
    (goto-char (point-max))
    (skip-chars-backward "\n\t ")
    (delete-region (point) (point-max))
    (unless (bobp) (insert "\n\n"))
    (insert bibtex "\n")
    (save-buffer)))

(defun my/biblio-selection-insert-append ()
  "Append current biblio entry to default bib file."
  (interactive)
  (biblio--selection-forward-bibtex #'my/biblio--append-to-default-bibfile))

(defun my/biblio-selection-insert-append-quit ()
  "Append current biblio entry to default bib file and quit."
  (interactive)
  (my/biblio-selection-insert-append)
  (quit-window))

(defun my/biblio-lookup-to-default-bib (&optional backend query)
  "Run `biblio-lookup' with default bib file as target context."
  (interactive)
  (let ((target (find-file-noselect my/biblio-default-bibfile)))
    (with-current-buffer target
      (biblio-lookup backend query))))

(provide 'config-bibliography)
