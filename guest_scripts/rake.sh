#!/usr/bin/env bash

set -euxo pipefail

cd /mruby-rutile-emscripten/mruby
MRUBY_CONFIG=/mruby-rutile-emscripten/build_config.rb rake "$@"
