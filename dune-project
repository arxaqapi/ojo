(lang dune 3.6)

(name ojo)

(generate_opam_files true)

(source
 (github arxaqapi/ojo))

(authors "arxaqapi")

(maintainers "arxaqapi")

(license MIT)

(documentation https://github.com/arxaqapi/ojo)

(package
 (name ojo)
 (synopsis "CLI tool to watch for change in the specified files.")
 (description "Ojo is a CLI toot that executes a given command each time a specified file or directory content is modified.")
 (depends (ocaml (>= 4.14)) dune)
 (tags
  ()))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
