(defcustom my/default-font-height 140
  "Default font height for graphical frames.
Value is in 1/10 pt units (e.g., 140 = 14pt)."
  :type 'integer
  :group 'faces)

(defun my/apply-default-font-height ()
  "Apply `my/default-font-height' to default and fixed-pitch faces."
  (interactive)
  (if (display-graphic-p)
      (progn
        (set-face-attribute 'default nil :height my/default-font-height)
        (set-face-attribute 'fixed-pitch nil :height 1.0)
        (message "Default font height set to %d" my/default-font-height))
    (message "No graphical frame active; saved font height %d for future GUI frames"
             my/default-font-height)))

(defun my/set-default-font-height (height)
  "Prompt for HEIGHT and apply it as the new default font height.
HEIGHT is in 1/10 pt units (e.g., 140 = 14pt)."
  (interactive (list (read-number "Default font height (e.g. 140 = 14pt): "
                                   my/default-font-height)))
  (setq my/default-font-height height)
  (my/apply-default-font-height))

(defun my/insert-tree-outline (dir)
  "Inserts a directory tree as collapsible Org-mode headlines.
The selected DIR becomes the Level 1 headline, with contents nested below."
  (interactive "DDirectory: ")
  (let* ((expanded-dir (expand-file-name dir))
         (default-directory (file-name-as-directory expanded-dir))
         ;; Get the folder name without the full path for the top headline
         (root-name (file-name-nondirectory (directory-file-name expanded-dir))))

    ;; 1. Insert the Root Directory as Level 1
    (insert (format "* %s/\n" root-name))

    ;; Run tree with:
    ;; -f (full path - relative to default-directory)
    ;; -i (no indentation lines)
    ;; -n (no color)
    ;; --dirsfirst (sort directories before files)
    (let ((output (shell-command-to-string "tree -fin --dirsfirst --noreport")))
      (dolist (line (split-string output "\n" t))
        (unless (string= line ".") ;; Skip the root dot, we handled it above
          (let* ((clean-line (replace-regexp-in-string "^\\./" "" line))
                 ;; Calculate depth by counting slashes
                 (depth (length (split-string clean-line "/")))
                 (name (file-name-nondirectory clean-line))
                 ;; Check if it's a directory and append slash if so
                 (display-name (if (file-directory-p clean-line)
                                   (concat name "/")
                                 name))
                 ;; 2. SHIFT DEPTH: Add 1 to depth so children start at **
                 (stars (make-string (1+ depth) ?*)))
            ;; Insert the headline
            (insert (format "%s %s\n" stars display-name))))))))

(defun my/insert-tree (dir)
  "Prompts for a directory and inserts a clean UTF-8 tree into an Org src block."
  (interactive "DDirectory: ")
  (let ((cmd (format "tree -n --charset=utf-8 '%s' | sed 's/\\xc2\\xa0/ /g'"
                     (expand-file-name dir))))
    (insert "#+BEGIN_SRC text\n")
    (insert (shell-command-to-string cmd))
    (insert "#+END_SRC\n")))

(defun xah-open-in-external-app (&optional Fname)
  "Open the file under the cursor or specified file in external app.
When called in emacs lisp, if Fname is given, open that.

URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
Version: 2019-11-04 2023-04-05 2023-06-26"
  (interactive)
  (let ((xfile (or Fname
       (if (eq major-mode 'dired-mode)
           (dired-get-file-for-visit)
         buffer-file-name))))
    (if xfile
  (let ((xoutBuf (get-buffer-create "*xah open in external app*")))
    (cond
     ((eq system-type 'windows-nt)
      (start-process "xah open in external app" xoutBuf
         "C:\\Program Files\\PowerShell\\7\\pwsh.exe"
         "-Command" "Invoke-Item" "-LiteralPath"
         (format "'%s'" (if (string-match "'" xfile) (replace-match "`'" t t xfile) xfile))))
     ((eq system-type 'darwin)
      (start-process "xah open in external app" xoutBuf "open" xfile))
     ((eq system-type 'gnu/linux)
      (start-process "xah open in external app" xoutBuf "xdg-open" xfile))
     ((eq system-type 'berkeley-unix)
      (let ((process-connection-type nil))
        (start-process "xah open in external app" nil "xdg-open" xfile))))
  (message "No file to open")))
    (message "No file associated with this buffer or under cursor")))

(defun xah-show-in-desktop ()
  "Show current file in desktop.
 (Mac Finder, Microsoft Windows File Explorer, Linux file manager)
This command can be called when in a file buffer or in `dired'.

URL `http://xahlee.info/emacs/emacs/emacs_show_in_desktop.html'
Version: 2020-11-20 2022-08-19 2023-06-26 2023-09-09"
  (interactive)
  (let ((xpath (if (eq major-mode 'dired-mode)
       (if (eq nil (dired-get-marked-files))
           default-directory
         (car (dired-get-marked-files)))
     (if buffer-file-name buffer-file-name default-directory))))
    (cond
     ((eq system-type 'windows-nt)
      (shell-command (format "PowerShell -Command invoke-item '%s'" (expand-file-name default-directory )))
      ;; (let ((xcmd (format "Explorer /select,%s"
      ;;                     (replace-regexp-in-string "/" "\\" xpath t t)
      ;;                     ;; (shell-quote-argument (replace-regexp-in-string "/" "\\" xpath t t ))
      ;;                     )))
      ;;   (shell-command xcmd))
      )
     ((eq system-type 'darwin)
      (shell-command
       (concat "open -R " (shell-quote-argument xpath))))
     ((eq system-type 'gnu/linux)
      (call-process shell-file-name nil 0 nil
        shell-command-switch
        (format "%s %s"
          "xdg-open"
          (file-name-directory xpath)))
      ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. eg with nautilus
      ))))

(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "M-<return>") 'xah-open-in-external-app)
  (define-key dired-mode-map (kbd "C-<return>") 'xah-show-in-desktop))

(provide 'config-custom-functions)
