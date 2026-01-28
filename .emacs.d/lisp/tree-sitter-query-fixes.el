;;; tree-sitter-query-fixes.el --- My personal fixes for tree-sitter queries.

;; This variable defines a COMPLETE and CORRECTED set of font-lock rules for C.
;; It does not depend on any c-ts-mode internal variables.
(defvar my-complete-c-ts-font-lock-rules
  '((comment) @font-lock-comment-face
    (string_literal) @font-lock-string-face
    (system_lib_string) @font-lock-string-face
    (preproc_arg) @font-lock-string-face
    (char_literal) @font-lock-string-face
    (preproc_directive) @font-lock-preprocessor-face
    (preproc_def) @font-lock-preprocessor-face
    (preproc_function) @font-lock-preprocessor-face
    (preproc_call) @font-lock-preprocessor-face
    (preproc_if) @font-lock-preprocessor-face
    (preproc_ifdef) @font-lock-preprocessor-face
    (number_literal) @font-lock-constant-face
    (null) @font-lock-constant-face
    (true) @font-lock-constant-face
    (false) @font-lock-constant-face
    (primitive_type) @font-lock-type-face
    (sized_type_specifier) @font-lock-type-face
    (storage_class_specifier) @font-lock-keyword-face
    (type_qualifier) @font-lock-keyword-face
    [
     "return"
     "case"
     "break"
     "continue"
     "default"
     "if"
     "else"
     "switch"
     "for"
     "while"
     "do"
     "goto"
     ] @font-lock-keyword-face
    (conditional_expression "?" @font-lock-keyword-face)
    (conditional_expression ":" @font-lock-keyword-face)
    (call_expression function: (field_expression field: (field_identifier) @font-lock-function-name-face))
    (call_expression function: (identifier) @font-lock-function-name-face)
    (call_expression function: (preproc_call (identifier) @font-lock-function-name-face))
    (function_declarator declarator: (identifier) @font-lock-function-name-face)
    (preproc_function name: (identifier) @font-lock-function-name-face)
    (preproc_def name: (identifier) @font-lock-function-name-face)
    (type_definition type: (struct_specifier (type_identifier) @font-lock-type-face))
    (type_definition type: (union_specifier (type_identifier) @font-lock-type-face))
    (type_definition type: (enum_specifier (type_identifier) @font-lock-type-face))
    (type_definition declarator: (type_identifier) @font-lock-type-face)
    (struct_specifier (type_identifier) @font-lock-type-face)
    (union_specifier (type_identifier) @font-lock-type-face)
    (enum_specifier (type_identifier) @font-lock-type-face)
    (parameter_declaration type: (type_identifier) @font-lock-variable-name-face)
    (labeled_statement label: (statement_identifier) @font-lock-variable-name-face)
    (goto_statement label: (statement_identifier) @font-lock-constant-face)
    ;; This is our corrected query, now part of a complete, self-contained list.
    ((declaration
      type: (macro_type_specifier name: (identifier) @_name) @for-each-tail
      (match @_name "^FOR_EACH_(?:ALIST_VALUE|FRAME|LIVE_BUFFER|TAIL(?:_SAFE)?)$")))
    (escape_sequence) @font-lock-warning-face))

;; This function now simply overwrites the rules with our self-contained list.
(defun my-fix-c-ts-mode-queries ()
  "Forcefully overwrite the font-lock rules with a corrected version."
  (setq-local treesit-font-lock-rules my-complete-c-ts-font-lock-rules))

(provide 'tree-sitter-query-fixes)

;;; tree-sitter-query-fixes.el ends here
