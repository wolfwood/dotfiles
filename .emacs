(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/haskell-mode-2.4")

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


(load-file "~/.emacs.d/graphviz-dot-mode.el") 
;(require 'graphviz-dot-mode)

(require 'generic-x)

(when (locate-library "javascript")
  (autoload 'javascript-mode "javascript" nil t)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode)))

;;(add-to-list 'load-path "~/.emacs.d/haskellmode")

(setq auto-mode-alist (cons '( "\\.hs\\'" . haskell-mode ) auto-mode-alist ))

(require 'haskell-mode)
;;(load "~/.emacs.d/haskellmode/haskell-site-file")

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
 '(inhibit-startup-screen t)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "bitstream" :family "Bitstream Vera Sans Mono")))))


;;(add-hook 'window-configuration-change-hook
;;					(lambda ()
;;						(setq frame-title-format
;;									(concat
;;									 invocation-name "@" system-name ": "
;;									 (replace-regexp-in-string
;;										(concat "/home/" user-login-name) "~"
;;										(or buffer-file-name "%b"))))))
