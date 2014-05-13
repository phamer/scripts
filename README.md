Scripts
=========================

Repository of some scripts I use, in most cases probably too specialized to run out-of-the box on every setup ;)

#### gitColorLogMessage.pl
For commit messages grouped by '[file/section]' ... at the beginning of the message, colorize same sections in same color.
One way to use it is to put the script in $PATH and add an alias

```
lg = !git log --color --graph --pretty=format:'%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset %C(yellow)%d%Creset' | gitColorLogMessage.pl | less -RXSF
```
**Important** is the "-" after the hash and **no** color code between "-" and the message! Not event a *%Creset*
