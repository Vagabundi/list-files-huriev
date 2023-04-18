#!/bin/bash

# Перевірка наявності вхідного та вихідного параметрів
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <filename> <new_extension>"
  exit 1
fi

# Виокремлення імені файлу та його розширення
filename=$(basename -- "$1")
extension="${filename##*.}"

# Перевірка наявності розширення в вихідному імені файла
if [ "$extension" = "$filename" ]; then
  echo "Error: file has no extension"
  exit 1
fi

# Заміна розширення на задане
new_extension="$2"
new_filename="${filename%.*}.$new_extension"

# Перевірка наявності файлу та виконання заміни розширення
if [ -e "$1" ]; then
  mv -- "$1" "${1%.*}.$new_extension"
  echo "File extension changed from .$extension to .$new_extension"
else
  echo "Error: file does not exist"
  exit 1
fi