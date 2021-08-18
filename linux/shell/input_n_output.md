## Input and output
### Read files
```
#!/bin/bash
read FILE

while read -r LINE; do
  echo "$LINE"
done < "$FILE"
```

### File descriptors and handles
```
#!/bin/bash
read FILE
# Number for file descriptor, >= 3
exec 5>$FILE     # write only
exec 5<$FILE     # read only
exec 5<>$FILE    # read and write

while read -r LINE; do
  echo "$LINE"
done <&5

echo "File was read on: `date`" >&5
exec 5>&-   # Close file
```

### IFS and Delimiting
Internal Field Separator is a space by default.
```
#!/bin/bash
read FILE
read DELIM

IFS="$DELIM"

while read -r var1 var2 var3; do
  echo "Part 1: var1"
  echo "Part 2: var2"
  echo "Part 3: var3"
done <"$FILE"
```
File content for testing can be something like:
- "i7 4GHz 16GB 4TB"
- "i7 4GHz|16GB|4TB"
- "i7 4GHz;16GB;4TB"

### Trap and Signals
`trap` takes two or more parameters.
- The 1st one being what to do when an event happens in single quotes.
- And then what we are trapping for.
```
# SIGINT: interrupt or CTRL + C
# SIGTERM: kill command except kill -9 which happens immediately at kernel level
# SIGTSTP: prevent to be 'CTRL + Z'ed
trap 'echo " - Please press Q to Exit.."' SIGINT SIGTERM SIGTSTP
while [ "$CHOICE" != "Q" ] && [ "$CHOICE" != "q" ]; do
  echo "MAIN MENU"
  echo "========="
  echo "1) Choice One"
  echo "2) Choice Two"
  echo "3) Choice Three"
  echo "Q) Quit/Exit"
  echo ""
  read CHOICE

  clear
done
```
