# Snippit (WIP)

[![CI](https://github.com/spenserblack/snippit/actions/workflows/ci.yml/badge.svg)](https://github.com/spenserblack/snippit/actions/workflows/ci.yml)
[![CodeQL](https://github.com/spenserblack/snippit/actions/workflows/codeql.yml/badge.svg)](https://github.com/spenserblack/snippit/actions/workflows/codeql.yml)
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
