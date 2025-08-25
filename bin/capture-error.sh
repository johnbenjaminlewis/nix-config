#!/bin/bash

for f in $(find . -name '*nix'); do
    echo -e "# **** start of $f ***\n\n"
    cat $f
    echo -e "# **** end of $f ***\n\n"
done

make build 2>&1
