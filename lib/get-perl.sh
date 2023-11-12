#!/bin/bash

echo add .
echo git commit -m auto .
find /etc/perl -type d -printf 'mkdir -p perl/%P\n'
find /etc/perl -type f -printf 'cp %p perl/%P\n'

