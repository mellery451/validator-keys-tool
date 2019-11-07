#!/bin/bash -u
# Exit if anything fails. Echo commands to aid debugging.
set -ex

pip install --user requests==2.13.0
pip install --user https://github.com/codecov/codecov-python/archive/master.zip

bash ci/install-boost.sh

