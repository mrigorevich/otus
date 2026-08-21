#! /bin/bash

echo "Введите имя интересующего процесса:"
read process_name

pid=$(find /proc/ -type l -exec ls -l {} + 2>/dev/null | grep -i "$process_name" | awk -F'/' '{print $3}' | sort -u)

echo "$pid" | while read -r pid; do
stat=$(cat "/proc/$pid/stat" | awk '{print $3}')
ppid=$(cat "/proc/$pid/stat" | awk '{print $4}')
cmd=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)

echo "$pid | $ppid | $stat | $cmd"
done
