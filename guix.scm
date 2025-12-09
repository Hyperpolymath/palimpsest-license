;;; Palimpsest License - Guix Package Definition
;;; SPDX-License-Identifier: Palimpsest-0.4 OR MIT
;;;
;;; This file defines the Palimpsest package for GNU Guix.
;;; Use: guix build -f guix.scm
;;; Or:  guix shell -D -f guix.scm (for development)

(use-modules (guix packages)
             (guix download)
             (guix git-download)
             (guix build-system dune)
             (guix build-system gnu)
             (guix licenses)
             (guix gexp)
             (gnu packages ocaml)
             (gnu packages base)
             (gnu packages version-control))

;;; ---------------------------------------------------------------------------
;;; Main Package Definition
;;; ---------------------------------------------------------------------------

(define-public palimpsest
  (package
    (name "palimpsest")
    (version "0.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hyperpolymath/palimpsest-license")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0000000000000000000000000000000000000000000000000000"))))
    (build-system dune-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-before 'build 'enter-ocaml-directory
           (lambda _
             (chdir "ocaml")
             #t))
         (add-after 'install 'install-docs
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (doc (string-append out "/share/doc/palimpsest")))
               (mkdir-p doc)
               (chdir "..")
               (for-each (lambda (file)
                           (install-file file doc))
                         '("README.md" "GOVERNANCE.md" "CONTRIBUTING.md"))
               (copy-recursively "LICENSES" (string-append doc "/LICENSES"))
               (copy-recursively "GUIDES_v0.4" (string-append doc "/GUIDES"))
               #t))))))
    (native-inputs
     (list ocaml
           dune
           ocaml-odoc))
    (propagated-inputs
     (list ocaml-yojson
           ocaml-ppx-deriving
           ocaml-cmdliner
           ocaml-fmt
           ocaml-logs))
    (synopsis "AI-era licensing framework for creative work")
    (description
     "The Palimpsest License is a licensing framework designed for creative
work in the age of AI.  It protects emotional lineage, enforces consent for
AI training, and provides quantum-proof traceability.

Key features:
@itemize
@item Explicit AI training consent mechanisms
@item Emotional lineage preservation
@item Bilingual legal framework (Dutch/English)
@item Machine-readable metadata
@item Consent registry integration
@end itemize")
    (home-page "https://palimpsestlicense.org")
    (license (list license:expat  ; MIT fallback
                   ;; Palimpsest-0.4 is not yet in Guix license list
                   ;; For now, use non-copyleft as placeholder
                   (license:non-copyleft
                    "https://palimpsestlicense.org/v0.4"
                    "Palimpsest License v0.4")))))

;;; ---------------------------------------------------------------------------
;;; Development Package (with test dependencies)
;;; ---------------------------------------------------------------------------

(define-public palimpsest-dev
  (package
    (inherit palimpsest)
    (name "palimpsest-dev")
    (native-inputs
     (modify-inputs (package-native-inputs palimpsest)
       (prepend ocaml-ounit2
                ocaml-alcotest
                ocaml-bisect-ppx
                ocaml-utop
                ocaml-merlin
                ocaml-ocaml-lsp
                git)))
    (synopsis "Palimpsest License development environment")))

;;; ---------------------------------------------------------------------------
;;; TUI Package (with terminal UI dependencies)
;;; ---------------------------------------------------------------------------

(define-public palimpsest-tui
  (package
    (inherit palimpsest)
    (name "palimpsest-tui")
    (propagated-inputs
     (modify-inputs (package-propagated-inputs palimpsest)
       ;; Nottui/Lwd for terminal UI
       (prepend ocaml-notty
                ocaml-lwd)))
    (synopsis "Palimpsest License terminal interface")))

;;; ---------------------------------------------------------------------------
;;; Channel Definition (for use in channels.scm)
;;; ---------------------------------------------------------------------------

;;; To use this as a Guix channel, create ~/.config/guix/channels.scm:
;;;
;;; (cons* (channel
;;;         (name 'palimpsest)
;;;         (url "https://github.com/hyperpolymath/palimpsest-license")
;;;         (branch "main")
;;;         (introduction
;;;          (make-channel-introduction
;;;           "COMMIT-HASH-HERE"
;;;           (openpgp-fingerprint
;;;            "KEY-FINGERPRINT-HERE"))))
;;;        %default-channels)

;;; ---------------------------------------------------------------------------
;;; Export for direct use
;;; ---------------------------------------------------------------------------

;; This allows: guix build -f guix.scm
palimpsest
