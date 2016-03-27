#!/usr/bin/env bash
#
# fix all permissions inside our workbench root directory
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

find ./ -name '*.sh' | xargs chmod +x
