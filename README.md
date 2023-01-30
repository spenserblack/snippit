# Snippit

[![Gem Version](https://badge.fury.io/rb/snippit.svg)](https://badge.fury.io/rb/snippit)
[![CI](https://github.com/spenserblack/snippit/actions/workflows/ci.yml/badge.svg)](https://github.com/spenserblack/snippit/actions/workflows/ci.yml)
[![CodeQL](https://github.com/spenserblack/snippit/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/spenserblack/snippit/actions/workflows/github-code-scanning/codeql)
[![codecov](https://codecov.io/gh/spenserblack/snippit/branch/main/graph/badge.svg?token=5yr1302Knn)](https://codecov.io/gh/spenserblack/snippit)

Define, store, and output your code snippets.

## Usage

All uses of `snippit` can be replaced with the shortcut `snip`.

```console
# Define a snippet called "hello-world.js"
$ snippit --save hello-world.js

# Set the slug and descriptive name of the snippet
$ snippit --save hello-world.js --slug hw-js --name "JavaScript Starter"

# Output the "JavaScript Starter" snippet to a file called "index.js"
$ snippit --get hw-js > index.js

# List all of your code snippets
$ snippit --list
```

## How it works

Code snippets get stored in a directory called `.snippit` in your home
directory. The actual code snippet filenames are slugified versions of the
snippet name. `.__definitions__.yml` is a reserved filename, as it is used to
map snippet slugs (filenames) to their human-readable names.
