;;; matcha-org.el --- Integration with Hydra. -*- lexical-binding: t -*-

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
(require 'org)

(defhydra matcha-org-babel (:color blue :columns 4)
  "Babel"
  ("e" org-babel-execute-src-block "Execute Source Block")
  ("'" org-edit-src-code "Edit Source"))

(defhydra matcha-org-hyperlink (:color blue :hint nil)
  "

    Org Links
  ------------------------------------------------------------------------------
    _l_ Store Link    _i_ Insert Link    _g_ Follow Link

    _n_ Next Link     _p_ Previous Link

    _t_ Toggle Link Display    _r_ Occur Links

"
  ("l" org-store-link)
  ("s" org-store-link)
  ("r" org-occur-link-in-agenda-files)
  ("i" org-insert-link)
  ("g" org-open-at-point)
  ("n" org-next-link)
  ("p" org-previous-link)
  ("t" org-toggle-link-display))

(defhydra matcha-org-time (:color blue :columns 4)
  "Time"
  ("t" org-time-stamp "Timestamp")
  ("T" org-time-stamp-inactive "Inactive Timestamp")
  ("D" matcha-org-change-date/body "Change Date")
  ("y" org-evaluate-time-range "Evaluate Time Range")
  ("s" org-schedule "Schedule Item")
  ("d" org-deadline "Deadline")
  ("Z" org-toggle-time-stamp-overlays "Custom Time Format")
  ("c" org-goto-calendar "Goto Calendar")
  ("C" org-date-from-calendar "Date from Calendar")
  ("0" org-timer-start "Start Timer")
  ("9" org-timer-pause-or-continue "Pause/Continue Timer")
  ("8" org-timer-pause-or-continue "Pause/Continue Timer")
  ("7" org-timer "Insert Timer String")
  ("6" org-timer-item "Insert Timer Item"))

(defhydra matcha-org-change-date (:color blue :columns 4)
  "Change Date"
  ("l" org-shiftright "1 Day Later")
  ("h" org-shiftleft "1 Day Before")
  ("k" org-shiftup "1 ... Later")
  ("j" org-shiftdown "1 ... Before"))

(defhydra matcha-org-editing (:color blue :hint nil)
  "

    Org: %s(matcha-heading-current-file)


    Insert                       Promotion                   Mark
  ------------------------------------------------------------------------------
    _m_ Heading          _<left>_ Promote Heading      _e_ Element
    _M_ Heading Under    _<right>_ Demote Heading      _@_ Subtree
    _t_ Todo             _s<left>_ Promote Subtree
    _T_ Todo Under       _s<right>_ Demote Subtree
                         ^^_<up>_ Move Subtree Up
                         ^^_<down>_ Move Subtree Down


    Subtree            Modify                   Narrow
  ------------------------------------------------------------------------------
    _x_ Cut        _r_ Refile             _ns_ Narrow to Subtree
    _w_ Copy       _\^_ Sort             _nb_ Narrow to Block
    _y_ Paste      _*_ Toggle Heading     _nw_ Widen
    _Y_ Yank
    _W_ Clone

"
  ("m" org-meta-return)
  ("M" org-insert-heading-respect-content)
  ("t" org-insert-todo-heading)
  ("T" org-insert-todo-heading-respect-content)
  ("<left>" org-do-promote)
  ("<right>" org-do-demote)
  ("s<left>" org-promote-subtree)
  ("s<right>" org-demote-subtree)
  ("<up>" org-move-subtree-up)
  ("<down>" org-move-subtree-down)
  ("e" org-mark-element :color red)
  ("@" org-mark-subtree :color red)
  ("x" org-cut-subtree)
  ("w" org-copy-subtree)
  ("y" org-paste-subtree)
  ("Y" org-yank)
  ("W" org-clone-subtree-with-time-shift)
  ("r" org-refile)
  ("^" org-sort)
  ("*" org-toggle-heading)
  ("ns" org-narrow-to-subtree)
  ("nb" org-narrow-to-block)
  ("nw" widen))

(defhydra matcha-org-mode (:color blue :hint nil)
  "

    Org: %s(matcha-heading-current-file)

    Motion                    Misc
  ------------------------------------------------------------------------------
    _n_ Next Heading        _e_ Editing
    _p_ Previous Heading    _B_ Babel
    _f_ Forward Level       _t_ Time
    _b_ Backward Level      _l_ Links
    _u_ Up Heading
    _j_ Goto

"
  ("n" org-next-visible-heading :color red)
  ("p" org-previous-visible-heading :color red)
  ("f" org-forward-heading-same-level :color red)
  ("b" org-backward-heading-same-level :color red)
  ("u" outline-up-heading :color red)
  ("j" org-goto)

  ("e" matcha-org-editing/body)
  ("B" matcha-org-babel/body)
  ("t" matcha-org-time/body)
  ("l" matcha-org-hyperlink/body))

(define-transient-command matcha-org-babel ()
  "Babel"
  ["Babel"
   ("e" "Execute Source Block" org-babel-execute-src-block )
   ("'" "Edit Source" org-edit-src-code )])

(define-transient-command matcha-org-hyperlink ()
  "Org Links"
  [["Navigate"
    ("g" "Follow Link" org-open-at-point)
    ("n" "Next Link" org-next-link)
    ("p" "Previous Link" org-previous-link)
    ("r" "Occur Links" org-occur-link-in-agenda-files)]
   ["Manage"
    ("l" "Store Link" org-store-link)
    ("i" "Insert Link" org-insert-link)
    ("t" "Toggle Link Display" org-toggle-link-display)]]
  [:hide (lambda () t)
         ("s" org-store-link)])

(define-transient-command matcha-org-time ()
  "Time"
  [["Insert"
    ("t" "Timestamp" org-time-stamp)
    ("T" "Inactive Timestamp" org-time-stamp-inactive)
    ("s" "Schedule Item" org-schedule)
    ("d" "Deadline" org-deadline)]
   ["Calendar"
    ("c" "Goto Calendar" org-goto-calendar)
    ("C" "Date from Calendar" org-date-from-calendar)]
   ["Manage"
    ("D" "Change Date..." matcha-org-change-date)
    ("y" "Evaluate Time Range" org-evaluate-time-range)
    ("Z" "Custom Time Format" org-toggle-time-stamp-overlays)]
   ["Timer"
    ("0" "Start Timer" org-timer-start)
    ("9" "Stop Timer" org-timer-stop)
    ("8" "Pause/Continue Timer" org-timer-pause-or-continue)
    ("7" "Insert Timer String" org-timer)
    ("6" "Insert Timer Item" org-timer-item)]])

(define-transient-command matcha-org-change-date ()
  "Change Date"
  ["Change Date"
   ("l" "1 Day Later" org-shiftright)
   ("h" "1 Day Before" org-shiftleft)
   ("k" "1 ... Later" org-shiftup)
   ("j" "1 ... Before" org-shiftdown)])

(define-transient-command matcha-org-editing ()
  "Edit"
  [["Insert"
    ("m" "Heading" org-meta-return)
    ("M" "Heading Under" org-insert-heading-respect-content)
    ("t" "Todo" org-insert-todo-heading)
    ("T" "Todo Under" org-insert-todo-heading-respect-content)]
   ["Promotion"
    ("<left>" "Promoto Heading" org-do-promote)
    ("<right>" "Demote Heading" org-do-demote)
    ("S-<left>" "Promote Subtree" org-promote-subtree)
    ("S-<right>" "Demote Subtree" org-demote-subtree)
    ("<up>" "Move Subtree Up" org-move-subtree-up)
    ("<down>" "Move Subtree Down" org-move-subtree-down)]
   ["Mark"
    ("e" "Element" org-mark-element)
    ("@" "Subtree" org-mark-subtree)]]
  [["Subtree"
    ("x" "Cut" org-cut-subtree)
    ("w" "Copy" org-copy-subtree)
    ("y" "Paste" org-paste-subtree)
    ("Y" "Yank" org-yank)
    ("W" "Clone" org-clone-subtree-with-time-shift)]
   ["Modify"
    ("r" "Refile" org-refile)
    ("^" "Sort" org-sort)
    ("*" "Toggle Heading" org-toggle-heading)]
   ["Narrow"
    ("ns" "Narrow to Subtree" org-narrow-to-subtree)
    ("nb" "Narrow to Block" org-narrow-to-block)
    ("nw" "Widen" widen)]])

(define-transient-command matcha-org-mode ()
  "Org Mode"
  ["Motion"
   ("n" "Next Heading" org-next-visible-heading)
   ("p" "Previous Heading" org-previous-visible-heading )
   ("f" "Forward Level" org-forward-heading-same-level)
   ("b" "Backward Level" org-backward-heading-same-level)
   ("u" "Up Heading" outline-up-heading)
   ("j" "Goto" org-goto)]
  ["Misc"
   ("e" "Editing..." matcha-org-editing)
   ("B" "Babel..." matcha-org-babel)
   ("t" "Time..." matcha-org-time)
   ("l" "Links..." matcha-org-hyperlink)
   ("r" "Reveal" org-reveal)])

(defun matcha-org-set-launcher ()
  "Set `hydra' launcher for `org'."
  (matcha-set-mode-command :mode 'org-mode :command #'matcha-org-mode)
  (matcha-set-eval-command :mode 'org-mode :command #'matcha-org-editing))

(provide 'matcha-org)
;;; matcha-org.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved noruntime cl-functions obsolete)
;; End:
