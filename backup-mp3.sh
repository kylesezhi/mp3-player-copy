#!/usr/bin/env bash
set -e
set -u
set -o pipefail

restic -r ~/Dropbox/Music/ backup ~/Downloads/mps/ --password-file .restic
