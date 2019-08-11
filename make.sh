#!/bin/sh

# The app builds directly to the docs folder that is hosted at Github pages.
# This way we always have a fresh site available if we ./make.sh before push.

# https://guide.elm-lang.org/webapps/
# https://guide.elm-lang.org/interop/
echo "* Running elm make"
elm make --debug src/Main.elm --output=docs/main.js

echo "* Done."
