First row:
``` shell
# !/bin/bash
```

Examples:
```
#!/bin/bash
tar cvfz homeuser.tgz /home/lev/

#!/bin/bash
BU=homeuser$(date +%Y%m%d).tgz
tar cvfz $BU $(pwd)
```

To run an unexecutable shell file:
```
    $ sh fname.sh
    $ ./fname.sh
```

## Core concepts

### Command Substitution
```
TODAY=`date`
UFILES=`find /home -user user`

echo "With Alias, TODAY is: $TODAY"
echo "With Alias, UFILES is: $UFILES"
```

```
shopt -s expand_aliases

alias TODAY="date"
alias UFILES="find /home -user user"

A=`TODAY`
B=`UFILES`

echo "With Alias, TODAY is: $A"
echo "With Alias, UFILES is: $B"
```

### Exit code
```
$ $?        # print last exit code
```

```
#!/bin/bash
set -e  # Stop shell when any command's exit code is not 0
```

### Arithmetic Operations
```
expr 1 + 1              # 2
expr 1+1                # 1+1
expr 10 / 2             # 5
expr 10 / 3             # May return error
expr 10 * 3             # Error
expr 10 \* 3            # 30
expr 10 % 3             # 1
expr ( 2 + 2 ) \* 4     # Error
expr \( 2 + 2 \) \* 4   # 16
```

### Global and local environment variables
- `$ set`: Shows shell-local variables and environment varialbes
    - Local variable: `a=1`
- `$ env`: Only sees environment variables
    - Environment variable: `export a=1`

### Special characters
```
echo $
echo $COL
echo "$COL"
echo '$COL'             # Print literal string in quote
echo "\$COL"
echo '$COL $DIM $COR'
echo "\$COL $DIM $COR"
```

### Using /dev/null
Balck hole of Linux system. Whatever you write to it, it's ignored.
Can be used to redirect output or errors.
```
$ ls -al >> /dev/null
$ echo "Hello World" > /dev/null
```

### The Read Statement
```
#!bin/bash
echo "Enter your age: "
read USERAGE

echo ""
echo "In 10 years, you will be `expr $USERAGE + 10` years old."
```

### Shell expansion `{}`
```
$ echo st{il,al}l           # still stall
$ export NEWPATH=$PATH:~
$ echo ~+                   # equivalent to PWD
$ echo ~-                   # equivalent to OLDPWD
$ echo "${!HO*}"            # Short for `env | grep "HO*"`
$ echo "${VARNAME:=value}"  # Set and print: `export VARNAME=value && echo VARNAME`
$ echo $[ 2 \ 2 ]           # No need "\*"
```

### Variable types
`declare` - Set, unset and display value of variables
- Readonly `-r`:
    - `$ declare -r READONLY="This is a string we cannot overwrite"`
    - `$ readonly MYREADONLY="This string"`
    - And cannot be unset

```
$ MYVAR=4
$ echo `expr $MYVAR + 4`
$ declare -p MYVAR
$ MYVAR="name"
$ echo `expr $MYVAR + 4`

$ declare -i NEWVAR=10
$ declare -p NEWVAR
$ NEWVAR="something"
$ echo $NEWVAR              # 0
$ NEWVAR=111

$ declare +i NEWVAR         # Unset type
$ declare -p NEWVAR
```

#### Array
```
$ MYARRAY=("First" "Second" "Third")
$ echo $MYARRAY                         # First
$ echo ${MYARRAY[0]}
$ echo ${MYARRAY[*]}                    # First Second Third
$ MYARRAY[3]="Fourth"
$ MYARRAY=("First","Second","Third")    # First,Second,Third
```

To iterate through an array:
```
#!/bin/bash
LIST=("01" "02" "03")
COUNT=0

for VAL in ${LIST[@]}; do
  echo "Processing: ${LIST[COUNT]}"
  COUNT="`expr COUNT + 1`"
done
```
