# Snippit (WIP)

[![Gem Version](https://badge.fury.io/rb/snippit.svg)](https://badge.fury.io/rb/snippit)
[![CI](https://github.com/spenserblack/snippit/actions/workflows/ci.yml/badge.svg)](https://github.com/spenserblack/snippit/actions/workflows/ci.yml)
[![CodeQL](https://github.com/spenserblack/snippit/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/spenserblack/snippit/actions/workflows/github-code-scanning/codeql)
[![codecov](https://codecov.io/gh/spenserblack/snippit/branch/main/graph/badge.svg?token=5yr1302Knn)](https://codecov.io/gh/spenserblack/snippit)

Define, store, and output your code snippets.

## (Proposed) Usage

All uses of `snippit` can be replaced with the shortcut `snip`.

```console
# Define a snippet called "hello-world.js"
$ snippit save hello-world.js

# Make a code snippet called "Hello World (JS)" from STDIN
$ echo "console.log('Hello, World!');" | snippit save --name "Hello World (JS)"

# Output the "Hello World (JS)" snippet to a file called "index.js"
$ snippit out "Hello World (JS)" > index.js

# List all of your code snippets
$ snippit list
```

## How it works

Code snippets get stored in a directory called `.snippit` in your home
directory. The actual code snippet filenames are slugified versions of the
snippet name. `__definitions__.yml` is a reserved filename, as it is used to
map snippet names to their filenames. You can either select a snippet by its
name or by its slugified name.
