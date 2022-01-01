;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
  (lambda ()
    (message "*** Emacs loaded in %s with %d garbage collections."
      (format "%.2f seconds"
        (float-time
          (time-subtract after-init-time before-init-time)))
       gcs-done)))

(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(use-package exec-path-from-shell
  :ensure t
  :config
    (setq exec-path-from-shell-variables '("PATH"))
    (exec-path-from-shell-initialize))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell nil)

(column-number-mode)
;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
  ;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq large-file-warning-threshold nil)

(setq vc-follow-symlinks t)

(use-package alert
  :ensure t
  :commands alert
  :config
  (setq alert-default-style 'notifications))

(use-package doom-themes
  :ensure t
  :defer t)
(load-theme 'doom-plain-dark t)

(set-face-attribute 'default nil
  :font "PragmataPro Mono Liga"
  :height 130
  :weight 'regular)
(use-package pragmatapro-lig
  :straight '(pragmatapro-lig
		 :type git
		 :host github
		 :repo "lumiknit/emacs-pragmatapro-ligatures"
		 :branch "master")
  :config
  (pragmatapro-lig-global-mode))

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

(use-package diminish
  :ensure t)

(use-package all-the-icons
  :ensure t)

(use-package minions
  :ensure t
  :hook (doom-modeline-mode . minions-mode))
(use-package doom-modeline
  :ensure t
  :custom-face
  (mode-line ((t (:height 0.85))))
  (mode-line-inactive ((t (:height 0.85))))
  :custom
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-mode-icon nil)
  :init
  (doom-modeline-init))

(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
  url-history-file (expand-file-name "url/history" user-emacs-directory))
;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering
  :ensure t)
;; Keep customization settings in a temporary file
(setq custom-file
	  (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory))
(load custom-file t)

(use-package auto-package-update
  :ensure t
  :custom
    (auto-package-update-interval 7)
    (auto-package-update-prompt-before-update t)
    (auto-package-update-hide-results t)
  :config
    (auto-package-update-maybe)
    (auto-package-update-at-time "09:00"))

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package expand-region
  :ensure t
  :diminish
  :commands er/expand-region
  :bind ("C-c i" . er/expand-region))

(use-package anzu
  :ensure t
  :diminish global-anzu-mode
  :config
    (global-anzu-mode)
  :bind (
    ("M-%" . anzu-query-replace)
    ("C-c r" . anzu-query-replace-regexp)))

(use-package ace-window
  :ensure t
  :diminish ace-window-mode
  :bind (("M-o" . ace-window)
         ("M-p" . ace-delete-window))
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package avy
  :ensure t
  :diminish avy-mode
  :bind (("C-;" . avy-goto-char)))

(use-package counsel
  :ensure t
  :diminish counsel-mode)
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :bind (("C-x b" . ivy-switch-buffer))
  :config
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "%d/%d ")
    (setq ivy-display-style 'fancy))
(use-package swiper
  :ensure t
  :diminish ivy-modex1
  :bind (("\C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-c C-f" . counsel-find-file))
  :config
    (progn
      (ivy-mode 1)
      (setq ivy-use-virtual-buffers t)
      (setq ivy-display-style 'fancy)))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :bind-keymap (("C-c p" . projectile-command-map))
  :init
    (progn
      (setq projectile-completion-system 'ivy)
      (setq projectile-enable-caching nil)
      (setq projectile-verbose nil)
      (setq projectile-do-log nil)
      (projectile-mode)))

(use-package ag
  :ensure t)

(use-package lsp-mode
  :ensure t
  :init
    (setq lsp-eldoc-render-all nil))

(use-package company
  :ensure t
  :custom
    (company-require-match nil)
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.2)
    (company-tooltip-align-annotation t)
    (company-frontends '(company-pseudo-tooltip-frontend
                               company-echo-metadata-frontend))
  :commands (company-mode global-company-mode company-complete
                          company-complete-common company-manual-begin
                          company-grab-line)
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :hook ((prog-mode . company-mode)
         (comint-mode . company-mode))
  :config (setq lsp-completion-provider :capf))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init
  (setq flycheck-disabled-checkers '(ruby-reek)))

(use-package ruby-mode
  :ensure t
  :interpreter "ruby"
  :mode "\\.rb$"
  :mode "\\.rake$"
  :mode "\\.gemspec$"
  :mode "\\.\\(pry\\|irb\\)rc$"
  :mode "/\\(Gem\\|Cap\\|Vagrant\\|Rake\\|Pod\\|Puppet\\|Berks\\)file$"
  :config
    (setq ruby-insert-encoding-magic-comment nil)
    (setq ruby-deep-indent-paren t)
  :init
    (add-hook 'ruby-mode-hook #'flycheck-mode)
    (add-hook 'ruby-mode-hook 'lsp))

(use-package rbenv
  :ensure t
  :diminish
  :init
    (progn
      (setq rbenv-show-active-ruby-in-modeline nil)
      (setq rbenv-modeline-function 'rbenv--modeline-plain))
      (global-rbenv-mode))

(use-package ruby-end
  :ensure t
  :diminish
  :init
    (add-hook 'ruby-mode-hook 'ruby-end-mode t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package git-gutter
  :ensure t
  :diminish git-gutter-mode
  :config
    (global-git-gutter-mode))

(use-package hydra
  :ensure t
  :bind(("C-c f" . hydra-flycheck/body)
        ("C-c m" . hydra-magit/body)
        ("C-c p" . hydra-projectile/body)))

(defhydra hydra-projectile (:color gray
                            :exit t
                            :hint nil)
"
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━^^^━━━━━━━━━━^^^━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                         ^^^Projectile^^^                      ┃
    ┣━━━━━^━━━━━━━━━^━━━━━┳━━━━━^━━━━━━━━━━^━━━━┳━━━━━^━━━━━━━^━━━━━┫
    ┃     ^ Search^     ┃     ^ Buffers^    ┃     ^Other^     ┃
    ┣━━━━━^━━━━━━━━━^━━━━━╋━━━━━^━━━━━━━━━━^━━━━╋━━━━━^━━━━━━━^━━━━━┫
    ┃ _f_: file           ┃ _l_: list           ┃ _i_: reset cache  ┃
    ┃ _d_: directory      ┃ _k_: kill all       ┃^ ^                ┃
    ┃ _p_: project        ┃^ ^                  ┃^ ^                ┃
    ┃ _s_: grep           ┃^ ^                  ┃^ ^                ┃
    ┗━━━━━^━━━━━━━━━^━━━━━┻━━━━━^━━━━━━━━━━^━━━━┻━━━━━^━━━━━━━^━━━━━┛
"
  ("f" projectile-find-file)
  ("d" projectile-find-dir)
  ("p" projectile-switch-project)
  ("s" projectile-ag)
  ("l" projectile-switch-to-buffer)
  ("k" projectile-kill-buffer)
  ("i" projectile-invalidate-cache))
