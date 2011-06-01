;; -- Paths --
(setq load-path (append load-path (list "~/.emacs.d")))


;; -- Global Emacs Config --
(setq default-tab-width 2)
(global-font-lock-mode t)
(setq font-lock-verbose nil)

(color-theme-zenburn)


;; -- File-specific Syntactic Highlighting Modes --
;; Languages
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(setq auto-mode-alist (cons '( "\\.d[i]?\\'" . d-mode ) auto-mode-alist ))

(autoload 'haskell-mode "haskell-mode" nil t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)

;(autoload 'graphviz-dot-mode "graphviz-dot-mode" nil t)

;(when (locate-library "javascript")
;  (autoload 'javascript-mode "javascript" nil t)
;  (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode)))

;; Config Filess
;(when (locate-library "xrdb-mode")
;  (require 'xrdb-mode)
;  (setq auto-mode-alist
;	(append '(("\\.Xdefaults$"    . xrdb-mode)
;		  ("*.\\.xrdb$"         . xrdb-mode)
;		  )
;		auto-mode-alist)))


;; -- Menu-driven Configuration Choices --
(custom-set-variables
 '(inhibit-startup-screen t)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
