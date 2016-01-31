#!/usr/bin/env bash
#
# fix all permissions inside our workbench root directory
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e
chmod +x *.sh
find ./ -name 'console' -or -name '*.sh' | xargs chmod +x
