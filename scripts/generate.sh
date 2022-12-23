#!/usr/bin/env bash

set -eux

while read -r file; do
	jsonnet -o "${file%net}" "jsonnet/$file"
done < <(ls jsonnet)
