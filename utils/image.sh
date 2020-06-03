#!/bin/bash

# Input might be padded, get the real length from the SquashFS header.
sqlen=$(($(dd status=none bs=1 skip=40 count=4 <$1 | od -An -t u4)))

# Un-pad
cp $1 $2
truncate -s $sqlen $2

# Sum it, put each sum-byte on its own line.
sum=$(sha1sum $2 | cut -d" " -f 1 | fold -w 2)

# Append the sum-bytes in binary form.
for byte in $sum; do
    printf "\x$byte" >>$2
done

# Re-pad
truncate -s %4K $2
