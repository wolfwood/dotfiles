;; -- Paths --
(setq load-path (append load-path (list "~/.emacs.d")))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")


;; -- Disable annoying stuffs --
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)


;; -- Global Emacs Config --
(setq default-tab-width 2)
(global-font-lock-mode t)
(setq font-lock-verbose nil)
(setq-default show-trailing-whitespace t)

(setq vcursor-key-bindings 't)      ;; enable default bindings to try it out
(load "vcursor")

;; always drop trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; -- File-specific Syntactic Highlighting Modes --
;; Languages
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(setq auto-mode-alist (cons '( "\\.d[i]?\\'" . d-mode ) auto-mode-alist ))

(autoload 'haskell-mode "haskell-mode" nil t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)

(autoload 'graphviz-dot-mode "graphviz-dot-mode" nil t)

(autoload 'rust-mode "rust-mode" nil t)


;; -- Menu-driven Configuration Choices --
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("27470eddcaeb3507eca2760710cc7c43f1b53854372592a3afa008268bcf7a75" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; -- Zenburn! --
;; has to come after the theme is marked safe :)
(load-theme 'zenburn)
