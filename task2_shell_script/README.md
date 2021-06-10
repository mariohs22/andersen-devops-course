# Shell script

**Current status: done**

## Task description

Write shell script that doing this one-line command:

```
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done
```

**Mandatory requirements:**

- the script must accept PID or process name as argument
- the number of output lines must be adjusted by the user
- should be able to see other connection states (listening, established, wait)
- the script should display clear error messages
- the script should not depend on launch privileges, should display a warning

_Optional requirements:_

- the script displays the number of connections to each organization
- the script allows you to get other data from the `whois` output
- the script can work with `ss`, uses other command-line utils

## Task plan

1. Parse the command string:

```
sudo
  netstat -tunapl |
    awk '/firefox/ {print $5}' |
      cut -d: -f1 |
        sort |
          uniq -c |
            sort |
              tail -n5 |
                grep -oP '(\d+\.){3}\d+' |
                  while read IP ;
                    do whois $IP |
                      awk -F':' '/^Organization/ {print $2}' ;
                  done
```

1.1. [Sudo](https://www.sudo.ws/) runs next command as root user.

1.2. [Netstat](https://net-tools.sourceforge.io/man/netstat.8.html) is a command-line network utility that displays network connections. With options:

-t - show TCP connections,

-u - show UDP connections,

-n - show numerical addresses instead of trying to determine symbolic host, port or user names,

-a - show both listening and non-listening sockets,

-p - show the PID and name of the program to which each socket belongs,

-l - show only listening sockets.

1.3. The `|` symbol used to create a combination of commands to accomplish something no single command can do - pipeline. A [pipeline](https://www.arachnoid.com/linux/shell_programming.html) `|` takes the output of one command and makes it the input to another command.

1.4. [Awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html) is a domain-specific language designed for text processing and typically used as a data extraction and reporting tool.

Options `/firefox/ {print $5}` means get column #5 (Foreign Address) of a previous netstat output for `firefox` program name.

1.5. [Cut](<https://en.wikipedia.org/wiki/Cut_(Unix)>) is a command line utility which is used to extract sections from each line of input.

Options `-d: -f1` means output the first field of each line using the colon character `:` as the field delimiter.

1.6. [Sort](<https://en.wikipedia.org/wiki/Sort_(Unix)>) is a command line utility, that prints the lines of its input or concatenation of all files listed in its argument list in sorted order. Running sort without any params means sorting in alphabetical order.

1.7. [Uniq](https://en.wikipedia.org/wiki/Uniq) is a command line utility, which outputs the text with adjacent identical lines collapsed to one, unique line of text.

Option `-c` used to prefix lines by the number of occurrences.

1.8. [Tail](<https://en.wikipedia.org/wiki/Tail_(Unix)>) is a command line utility used to display the tail end of a text file or piped data.

Option `-n5` used to display last 5 lines.

1.9. [Grep](https://www.gnu.org/software/grep/) is a command-line utility for searching plain-text data sets for lines that match a regular expression.

Option `-oP '(\d+\.){3}\d+'` means print only the matched (non-empty) parts of matching lines, with each such part on a separate output line, use Perl-compatible regular expression `(\d+\.){3}\d+`.

Regular expression `(\d+\.){3}\d+` used to match IP-address: 3 substrings of '_1 or nore digits with `.` on its end_' and 1 or more digit after last substring.

1.10. [While ... done](https://www.shellscript.sh/loops.html) means while loop in unix shell.

1.11. [Read](https://www.opennet.ru/man.shtml?topic=read&category=1&russian=5) is a command-line utility that reads a line from standard input.

Operand `IP` used to specify the name of a shell variable (used later in while loop).

1.12. [Whois](https://en.wikipedia.org/wiki/WHOIS) is a command-line utility used to make WHOIS protocol queries. The WHOIS databases stores the registered users or assignees of an Internet resource, such as a domain name, an IP address block or wide range of other information.

Operand `$IP` means WHOIS query to IP address specified in while loop.

1.13. Awk with options `-F':' '/^Organization/ {print $2}'` means get column #2 (Foreign Address) of a previous whois output for `Organization` name, using `:` as input field separator.

**Summary** This one-line command displays WHOIS `Organization` field of last 5 firefox connections.

2. Write shell script. Use [Minimal safe Bash script template](https://betterdev.blog/minimal-safe-bash-script-template/).

## Manual

Simple download connections.sh script and run. You must specify process name or PID as the script argument. Run this script as root to see more details.

```
Usage: connections.sh [-h] [-v] [-n 5] [-s] [-f organization] process

This script shows WHOIS information of a specified program (process or PID) current connections.

Required argument:

process         Specify process name or PID

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-n, --num_lines Set number of output lines, 5 by default
-s, --state     Choose connection state, all by default. Possible values: listen, established, time_wait, close_wait
-f, --field     WHOIS field to fetch, organization by default. Possible values: organization, domain, status

Usage example:

connections.sh firefox
connections.sh -n 10 -s established -f organization firefox
```
