#!/bin/bash

file=$1
echo -n "$file" | md5sum | tr -d " -"
