# Dash Docset for XMPP XEPs

This repository will automatically clone and generate a valid Dash Docset for XMPP XEPs.

### Update

The source XEPs to be included in the resulting docset are pulled automatically from the respective
[repository](https://github.com/xsf/xeps). Pulling and keeping this up-to-date is important in being
able to build a useful doc-set, and you can do this like so:

```sh
git submodule --remote --recursive
```

Building the docset might fail if the above was not done and this repository wasn't cloned via `git
clone --recursive`.

## Build

Building a new Docset requires a single command and a few dependencies:

  - `envsubst` for creating an info file from the templated source.
  - `sqlite3` for adding entries for XEPs in the embedded Dash database.
  - `xmllint` and `xsltproc` for actually building the HTML files for the XML source.
  - `tar` and `gzip` for building the final package.

With these dependencies in place, you can just run `make` in the root directory of the repository.

## License

All code in this repository is covered by the terms of the MIT License, the full text of which can
be found in the LICENSE file.

All other code, images, etc. are property of their respective owners.
