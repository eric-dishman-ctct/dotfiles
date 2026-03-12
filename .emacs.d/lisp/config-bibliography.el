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
              ("C-c b l" . vader/biblio-lookup-to-default-bib)
              :map biblio-selection-mode-map
              ("i" . vader/biblio-selection-insert-append)
              ("I" . vader/biblio-selection-insert-append-quit)))

;;------------------------------------------------------------------------------
;; Custom default bibliography file
;;------------------------------------------------------------------------------
(defvar vader/biblio-default-bibfile
  (expand-file-name "~/ref/bibliography.bib")
  "Default BibTeX file for biblio inserts.")

(defun vader/biblio--append-to-default-bibfile (bibtex _entry)
  (with-current-buffer (find-file-noselect vader/biblio-default-bibfile)
    (goto-char (point-max))
    (skip-chars-backward "\n\t ")
    (delete-region (point) (point-max))
    (unless (bobp) (insert "\n\n"))
    (insert bibtex "\n")
    (save-buffer)))

(defun vader/biblio-selection-insert-append ()
  "Append current biblio entry to default bib file."
  (interactive)
  (biblio--selection-forward-bibtex #'vader/biblio--append-to-default-bibfile))

(defun vader/biblio-selection-insert-append-quit ()
  "Append current biblio entry to default bib file and quit."
  (interactive)
  (vader/biblio-selection-insert-append)
  (quit-window))

(defun vader/biblio-lookup-to-default-bib (&optional backend query)
  "Run `biblio-lookup' with default bib file as target context."
  (interactive)
  (let ((target (find-file-noselect vader/biblio-default-bibfile)))
    (with-current-buffer target
      (biblio-lookup backend query))))

(provide 'config-bibliography)
