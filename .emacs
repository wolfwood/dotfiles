(add-to-list 'load-path "~/.emacs.d")

(autoload 'd-mode "d-mode" 
  "Major mode for editing D code." t)
(setq auto-mode-alist (cons '( "\\.d\\'" . d-mode ) auto-mode-alist ))

(setq default-tab-width 2)

;file-name-directory("~/.emacs.d/")

;(load "~/.emacs.d/color-theme.el")
;(load "~/.emacs.d/zenburn.el")

(require 'zenburn)

(color-theme-zenburn)
(global-font-lock-mode t)

(require 'generic-x)

(when (locate-library "javascript")
  (autoload 'javascript-mode "javascript" nil t)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode)))

;;(add-to-list 'load-path "~/.emacs.d/haskellmode")

;;(require 'haskell-mode)
(load "~/.emacs.d/haskellmode/haskell-site-file")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-hook 'haskell-mode-hook 'font-lock-mode)

(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(haskell-indent-offset 2)
 '(inhibit-startup-screen t)
 '(paren-match-face (quote paren-face-match-light))
 '(paren-sexp-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "urw" :family "Nimbus Mono L")))))
