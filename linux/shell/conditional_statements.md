## Conditional Statements

### Execution operators
- `||`: OR
- `&&`: AND

`rm somefile 2> /dev/null && echo "File exists and was removed" || echo "File not exists"`

### If statement
```
#!/bin/bash
$FILENAME=$1

if [ -f $FILENAME ] && [ -r $FILENAME ]
  then
    echo "File $FILENAME exists and is readable"
fi
```

### If/elif/else statement
```
#!/usr/bin/env bash

echo "Enter number 1 or 2: "
read VALUE

if [ "$VALUE" -eq "1" ] 2>/dev/null; then   # 2> redirects errors if user doesn't enter number
  echo "You entered #1"
elif [ "$VALUE" -eq "2" ] 2>/dev/null; then
  echo "You successfully entered #2"
else
  echo "You didn't follow the directions!"
fi
```

### For loop
```
#!/bin/bash
SHELLSCRIPTS=`ls *.sh`

for SCRIPT in "$SHELLSCRIPTS"; do
  DISPLAY="`cat $SCIPT`"
  echo "File: $SCRIPT - Contents: $DISPLAY"
done
```

### While loop
```
while [ ]; do
done
```

### Case
```
case $CHOICE in
  1)
    echo "1";;
  2)
    echo "2"
    ;;
  *)
    echo "default";;
```
