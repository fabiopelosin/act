# Act

Allows to act on files from the command line efficiently... `cat` for the twenty first century!

![act](http://cl.ly/image/0D2b2Y201l1E/Image%202014-04-04%20at%201.00.16%20am.png)

## Installation

```console
$ gem install act
$ [sudo] easy_install Pygments #optional
```

## Usage

```console
# Print a complete file
$ act lib/act/command.rb

0    require 'colored'
1    require 'claide'
2    require 'active_support/core_ext/string/strip'
3
4    module Act
5      class Command < CLAide::Command
6
7        self.command = 'act'
8        self.description = 'Act the command line tool to act on files'
9
10       def self.options
[...]

# Print the line 10 with the default context (5 lines)
$ act lib/act/command.rb:10

5    module Act
6      class Command < CLAide::Command
7
8        self.command = 'act'
9        self.description = 'Act the command line tool to act on files'
10
11       def self.options
12         [
13           ['--open', "Open the file in $EDITOR instead of printing it"],
14           ['--no-line-numbers', "Show output without line numbers"],
15           ['--version', 'Show the version of Act'],

# Open in $EDITOR the file at the given line
$ act lib/act/command.rb:10 --open

# Print from line 8 to line 12
$ act lib/act/command.rb:8-12

8    self.command = 'act'
9    self.description = 'Act the command line tool to act on files'
10
11   def self.options
12     [

# Print from line 10 with 2 lines of context
$ act lib/act/command.rb:10+2

8    self.command = 'act'
9    self.description = 'Act the command line tool to act on files'
10
11   def self.options
12     [

# Show ./lib/act/command.rb from line 8 to line 9
bin/act bin/act https://github.com/irrationalfab/act/blob/master/lib/act/command.rb\#L8-L9

8    self.command = 'act'
9    self.description = 'Act the command line tool to act on files'

# Open $EDITOR ./lib/act/command.rb at line 8
bin/act bin/act https://github.com/irrationalfab/act/blob/master/lib/act/command.rb\#L8-L9
```

## Help me beat [@orta](https://twitter.com/orta) in followers count

Follow [@fabiopelosin](https://twitter.com/fabiopelosin)
