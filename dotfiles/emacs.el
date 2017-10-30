(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(winner-mode 1)
(windmove-default-keybindings)
(global-font-lock-mode 1)
(show-paren-mode 1)
(scroll-bar-mode -1)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq js-indent-level 2)
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Looks

(require 'monokai-theme)
(load-theme 'monokai t)

(require 'git-gutter)
(global-git-gutter-mode +1)

(require 'diminish)
(diminish 'undo-tree-mode)
(diminish 'ivy-mode)
(diminish 'ws-butler-mode)

;; Utils

(require 'undo-tree)
(setq undo-tree-visualizer-timestamps t)
(global-undo-tree-mode)

(require 'ivy)
(ivy-mode 1)

(require 'projectile)
(projectile-mode 1)

(require 'counsel-projectile)
(counsel-projectile-on)
(global-set-key (kbd "C-c p f") 'counsel-projectile-find-file)

(require 'ace-jump-mode)
(global-set-key (kbd "C-c C-c") 'ace-jump-mode)

(require 'ws-butler)
(ws-butler-global-mode)

(require 'highlight-symbol)
(highlight-symbol-mode) 

(defun yank-to-x-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
        (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
        (message "Yanked region to clipboard!")
        (deactivate-mark))
    (message "No region active; can't yank to clipboard!")))

;; Org

(setq org-agenda-files (quote ("/home/utdemir/workspace/diary/diary.org")))

(setq org-adapt-indentation nil)
(setq org-list-description-max-indent 5)
(global-set-key (kbd "C-c a") 'org-agenda)

(define-key global-map (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(("i" "inbox" entry (file+headline "/home/utdemir/workspace/diary/diary.org" "Inbox")
         "* %?")
        ))

(defun my-org-update () (interactive)
  (magit-stage-modified)
  (magit-commit (list "-m" "update"))
  (call-interactively #'magit-push-current-to-upstream)
  )

(add-hook 'org-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-p") 'my-org-update)
             ))

;; Scala

(require 'scala-mode)
(require 'sbt-mode)


(defun my-sbt-compile () (interactive) (sbt-command "compile"))
(defun my-sbt-test () (interactive) (sbt-command "test"))

(add-hook 'scala-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-l") 'my-sbt-compile)
             (local-set-key (kbd "C-c C-t") 'my-sbt-test)
             ))

;; JavaScript

(setq js2-basic-offset 2)

;; Haskell

(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(setq haskell-process-wrapper-function
  (lambda (argv) (
    append (list "nix-shell" "-I" "." "--command")
           (list (mapconcat 'identity argv " "))
  ))
)
(setq haskell-process-type 'ghci)

(require 'hindent)
(add-hook 'haskell-mode-hook #'hindent-mode)