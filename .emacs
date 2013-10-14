
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Version check.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (< emacs-major-version 24)
  (error "This setup requires Emacs v24, or higher. You have: v%d" emacs-major-version))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Packaging setup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(package-initialize)

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(defvar my-packages '(evil 
		      evil-leader evil-tabs surround
		      elscreen ace-jump-mode
		      helm
		      key-chord
		      recentf
		      rainbow-delimiters highlight paredit smartparens
		      nrepl nrepl-eval-sexp-fu ac-nrepl
		      )
  "A list of packages to check for and install at launch.")

(defun my-packages-missing-p ()
  (let ((missing-p nil)) ()
       (dolist (package my-packages missing-p)
	 (or (package-installed-p package)
	     (setq missing-p t)))))

(when (my-packages-missing-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (package my-packages)
    (when (not (package-installed-p package))
      (package-install package))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Early requirements.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Customizations (from M-x customze-*)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu t)
 '(ac-auto-start t)
 '(ac-show-menu-immediately-on-auto-complete t)
 '(nrepl-hide-special-buffers t)
 '(nrepl-popup-stacktraces-in-repl t)
 '(recentf-max-saved-items 50))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Basic Vim Emulation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(evil-mode t)
(global-evil-tabs-mode 1)
(global-auto-complete-mode t)

(evil-ex-define-cmd "Exp[lore]" 'dired-jump)
(evil-ex-define-cmd "color[scheme]" 'customize-themes)

;; ACE jump 
(global-set-key (kbd "SPC") 'ace-jump-char-mode)
(global-set-key (kbd "C-SPC") 'ace-jump-line-mode)
(global-set-key (kbd "M-SPC") 'ace-jump-word-mode)

;; Ace jump
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Custom settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ensure we only have to specify y/n, not yes/no.
(fset 'yes-or-no-p 'y-or-n-p)

; Don't prompt about following symlinks.
(setq vc-follow-symlinks t)

; Show me the line and column number in the info bar.
(line-number-mode t)
(column-number-mode t)

; Disable the 'bell'
(setq ring-bell-function 'ignore)

; Smooth scrolling. Scrolls only one line at a time.
(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
    (setq-default scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)

; Indentation
(setq standard-indent 2)              ; Indentation set to 2 space.
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)   ; Don't allow tabs, just spaces.

; Emacs auto-indentation
(define-key global-map (kbd "RET") 'newline-and-indent)

; Disable the menu bars.
(menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Nice-to-haves...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-surround-mode t)
(smartparens-global-mode t)

(helm-mode t)
(recentf-mode t)

(evil-define-key 'normal global-map
  "\C-p" 'helm-mini
  "q:" 'helm-complex-command-history
  "\\\\w" 'evil-ace-jump-word-mode)

;;; Uncomment these key-chord lines if you like that "remap 'jk' to ESC" trick.
;; (key-chord-mode t)
;; (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Filetype-style hooks.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun standard-lisp-modes ()
  (require 'nrepl-eval-sexp-fu)
  (rainbow-delimiters-mode t)
  (local-set-key (kbd "RET") 'newline-and-indent))

;;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook
	  '(lambda ()
	     (standard-lisp-modes)))

(evil-define-key 'normal emacs-lisp-mode-map
  "\M-q" 'sp-indent-defun
  "\C-c\C-c" 'eval-defun
  "K" '(lambda ()
	 (interactive)
	 (describe-function (symbol-at-point))))

;;; Clojure
(add-hook 'clojure-mode-hook
	  '(lambda ()
	     (standard-lisp-modes)

	     (mapc '(lambda (char)
		      (modify-syntax-entry char "w" clojure-mode-syntax-table))
		   '(?- ?_ ?/ ?< ?> ?: ?' ?.))
  
	     (require 'clojure-test-mode)
  
	     (require 'ac-nrepl)
	     (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
	     (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
	     (add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
	     (add-to-list 'ac-modes 'nrepl-mode)))

(evil-define-key 'normal clojure-mode-map
  "\M-q" 'sp-indent-defun
  "gK" 'nrepl-src
  "K"  'ac-nrepl-popup-doc)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; COQ setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Need to figure out how to use proof general.
(setq auto-mode-alist (cons '("\\.v$" . coq-mode) auto-mode-alist))
(autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Better defaults
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Better defaults: https://github.com/technomancy/better-defaults
;;;###autoload
(ido-mode t)
(setq ido-enable-flex-matching t)

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'saveplace)
(setq-default save-place t)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

