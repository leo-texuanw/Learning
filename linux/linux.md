## Bash
### Core concepts

#### bash environment configuration files
##### .bash_profile
For when you login.

##### .bashrc
Execeuted before when you start a new bash instance.

##### .bash_history
use $HISTCONTROL to control what to be recorded, e.g. ignoredups, ignorespace

##### .bash_logout
Last thing you do when you logout a terminal. Not when the terminal is crossed.
```
# ~/.bash_logout
cp ~/.bashrc.original ~/.bashrc
```



## Variables
$ var="hello"
$ echo $var

## show a named node:
    ps aux | grep name
to find it's process ids

## then kill it
    kill -9 Pid
