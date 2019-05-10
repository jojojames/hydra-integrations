;; matcha-projectile.el --- Integration with Hydra. -*- lexical-binding: t -*-

;; Copyright (C) 2019 James Nguyen

;; Author: James Nguyen <james@jojojames.com>
;; Maintainer: James Nguyen <james@jojojames.com>
;; URL: https://github.com/jojojames/matcha
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: hydra, emacs
;; HomePage: https://github.com/jojojames/matcha

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;; Integration with Hydra.

;;; Code:
(require 'matcha-base)
;; (require 'projectile)

(defun matcha-projectile-root ()
  "Return path `matcha-projectile' can print in heading."
  (if (projectile-project-p)
      (file-name-nondirectory
       (directory-file-name
        (file-name-directory (projectile-project-root))))
    "Not in Project"))

(defhydra matcha-projectile (:color blue :hint nil :idle 0)
  "

    Projectile: %s(matcha-projectile-root)

    Files             Search          Buffer             Do
  ------------------------------------------------------------------------------
    _f_ File          _a_ Ag          _b_ Switch        _g_ Magit
    _l_ File dwim     _A_ Grep        _v_ Display       _P_ Commander
    _r_ Recent file   _s_ Occur       _i_ IBuffer       _I_ Info
    _d_ Dir           _S_ Replace     _K_ Kill all      _p_ Switch Project
    _o_ Other         _t_ Find Tag
    _u_ Test file     _T_ Make Tags
    _h_ Root          _R_ Replace Regexp

    Other Window      Run             Cache
  ------------------------------------------------------------------------------
    _F_ File          _U_ Test        _kc_ Clear
    _L_ Dwim          _m_ Compile     _kk_ Add Current
    _D_ Dir           _c_ Shell       _ks_ Cleanup
    _O_ Other         _C_ Command     _kd_ Remove
    _B_ Buffer

"
  ("a" projectile-ag)
  ("A" projectile-grep)
  ("b" projectile-switch-to-buffer)
  ("B" projectile-switch-to-buffer-other-window)
  ("c" projectile-run-async-shell-command-in-root)
  ("C" projectile-run-command-in-root)
  ("d" projectile-find-dir)
  ("D" projectile-find-dir-other-window)
  ("f" projectile-find-file)
  ("F" projectile-find-file-other-window)
  ("g" projectile-vc)
  ("h" projectile-dired)
  ("I" projectile-project-info)
  ("kc" projectile-invalidate-cache)
  ("kd" projectile-remove-known-project)
  ("kk" projectile-cache-current-file)
  ("K" projectile-kill-buffers)
  ("ks" projectile-cleanup-known-projects)
  ("l" projectile-find-file-dwim)
  ("L" projectile-find-file-dwim-other-window)
  ("m" projectile-compile-project)
  ("o" projectile-find-other-file)
  ("O" projectile-find-other-file-other-window)
  ("p" projectile-switch-project)
  ("P" projectile-commander)
  ("r" projectile-recentf)
  ("R" projectile-replace-regexp)
  ("s" projectile-multi-occur)
  ("S" projectile-replace)
  ("t" projectile-find-tag)
  ("T" projectile-regenerate-tags)
  ("u" projectile-find-test-file)
  ("U" projectile-test-project)
  ("v" projectile-display-buffer)
  ("i" projectile-ibuffer))

(define-transient-command matcha-projectile-cache ()
  "Cache"
  [["Cache"
    ("c" "Invalidate" projectile-invalidate-cache)
    ("d" "Remove Known Project" projectile-remove-known-project)
    ("k" "Cache Current File" projectile-cache-current-file)
    ("s" "Cleanup Known Projects" projectile-cleanup-known-projects)]])

(define-transient-command matcha-projectile ()
  "Projectile"
  [["Find"
    ("f" "File" projectile-find-file)
    ("F" "File Other Window" projectile-find-file-other-window)
    ("l" "File DWIM" projectile-find-file-dwim)
    ("L" "File DWIM Other Window" projectile-find-file-dwim-other-window)
    ("o" "Other File" projectile-find-other-file)
    ("O" "Other file Other Window" projectile-find-other-file-other-window)
    ("r" "Recent File" projectile-recentf)
    ("u" "Test File" projectile-find-test-file)]
   ["Buffers & Directories"
    ("b" "Buffer" projectile-switch-to-buffer)
    ("B" "Buffer Other Window" projectile-switch-to-buffer-other-window)
    ("d" "Directory" projectile-find-dir)
    ("D" "Directory Other Window" projectile-find-dir-other-window)]
   ["Actions"
    ("R" "Replace Regexp" projectile-replace-regexp)
    ("S" "Replace" projectile-replace)
    ("U" "Run Tests" projectile-test-project)
    ("m" "Compile Project" projectile-compile-project)
    ("c" "Run Async Shell Command" projectile-run-async-shell-command-in-root)
    ("C" "Run Command" projectile-run-command-in-root)]]
  [["Modes"
    ("g" "Version Control" projectile-vc)
    ("h" "Dired" projectile-dired)
    ("i" "IBuffer" projectile-ibuffer)]
   ["Search"
    ("a" "AG" projectile-ag)
    ("A" "Grep" projectile-grep)
    ("s" "Multi Occur" projectile-multi-occur)
    ("t" "Find Tag" projectile-find-tag)
    ("T" "Regenerate Tags" projectile-regenerate-tags)]
   ["Manage"
    ("p" "Switch Project" projectile-switch-project)
    ("I" "Project Info" projectile-project-info)
    ("K" "Kill Project Buffers" projectile-kill-buffers)
    ("k" "Cache..." matcha-projectile-cache)
    ("P" "Commander" projectile-commander)]])

(provide 'matcha-projectile)
;;; matcha-projectile.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved noruntime cl-functions obsolete)
;; End:
