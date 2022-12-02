(lang dune 3.6)

(name ojo)

(generate_opam_files true)

(source
 (github arxaqapi/ojo))

(authors "arxaqapi")

(maintainers "arxaqapi")

(license LICENSE)

(documentation https://github.com/arxaqapi/ojo)

(package
 (name ojo)
 (synopsis "ojo executes a specific command each time a specific file is modified.")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  ()))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
