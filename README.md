# Act
[![Build Status](https://travis-ci.org/irrationalfab/act.svg?branch=master)](https://travis-ci.org/irrationalfab/act)

Preview files from the command line efficiently. `cat` for the twenty first century!

<img src="http://cl.ly/image/0A2p320r442D/Image%202014-04-04%20at%202.59.18%20pm.png" height="50%" width="50%">

### Features

- Flexible input handling
  - Support for colon syntax
  - Support for GitHub like URLs
- Automatic syntax highlighting based on the file extension (via [Pygments](http://pygments.org))
- Fast enough for the task

## Installation

```console
$ [sudo] gem install act
$ [sudo] easy_install Pygments #optional
```

## Help needed

Follow [@fabiopelosin](https://twitter.com/fabiopelosin) to help me beat [@orta](https://twitter.com/orta) in followers count.

## Usage

Print a complete file:

```console
$ act lib/act/command.rb

0    require 'colored'
1    require 'claide'
2    require 'active_support/core_ext/string/strip'
[...]
```

Print the line 10 with the default context (5 lines):

```console
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

```

Open in `$EDITOR` the file at the given line:

```console
$ act lib/act/command.rb:10 --open
```

Print from line 8 to line 12:

```console
$ act lib/act/command.rb:8-12

8    self.command = 'act'
9    self.description = 'Act the command line tool to act on files'
10
11   def self.options
12     [

```

Print from line 10 with 2 lines of context:

```console
$ act lib/act/command.rb:10+2

8    self.command = 'act'
9    self.description = 'Act the command line tool to act on files'
10
11   def self.options
12     [

```

Show ./lib/act/command.rb from line 8 to line 9:

```console
$ act https://github.com/irrationalfab/act/blob/master/lib/act/command.rb\#L8-L9

8    self.command = 'act'
9    self.description = 'Act the command line tool to act on files'

```

Open `$EDITOR` ./lib/act/command.rb at line 8:

```console
$ act https://github.com/irrationalfab/act/blob/master/lib/act/command.rb\#L8-L9
```

