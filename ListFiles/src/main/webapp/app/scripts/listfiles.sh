#!/bin/bash

# вивід в файл і консоль
exec &> >(tee -a output.txt)

#в поточному каталозі
echo "Files in current directory:"
ls -p | grep -v /   # list all files, but not directories

#в заданому каталозі
if [ $# -eq 0 ]; then
  echo "No directory specified."
else
  echo "Files in specified directory:"
  ls -p $1 | grep -v /
fi

#порахувати кількість вкладених каталогів та файлів
num_files=$(find . -type f | wc -l)
num_dirs=$(find . -type d | wc -l)
echo "Number of nested files: $num_files"
echo "Number of nested directories: $num_dirs"

#вивести тільки назви файлів
echo "File names:"
find . -type f -printf "%f\n"

#вивести тільки назви каталогів
echo "Directory names:"
find . -type d -printf "%f\n"
