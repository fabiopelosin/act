require 'colored'
require 'claide'
require 'active_support/core_ext/string/strip'

module Act
  class Command < CLAide::Command

    self.command = 'act'
    self.description = 'Act the command line tool to act on files'

    def self.options
      [
        ['--open', "Open the file in $EDITOR instead of printing it"],
        ['--no-line-numbers', "Show output without line numbers"],
        ['--version', 'Show the version of Act'],
      ].concat(super)
    end

    def self.run(argv)
      argv = CLAide::ARGV.new(argv)
      if argv.flag?('version')
        puts VERSION
        exit 0
      end
      super(argv)
    end

    def initialize(argv)
      @open = argv.flag?('open')
      @number_lines = argv.flag?('line-numbers', true)
      @file = argv.shift_argument
      super
    end

    def validate!
      super
      help! "A file is required." unless @file
    end

    def run
      file_information = @file.split(':')
      path = file_information[0]
      line = file_information[1]
      context_lines = 5

      if @open
        command = Helper.open_in_editor_command(path, line)
        system(command)
      else
        string = File.read(path) if File.exists?(path)

        if string
          if line
            line = line.to_i
            start_line = Helper.start_line(string, line, context_lines)
            end_line = Helper.end_line(string, line, context_lines)
            string = Helper.select_lines(string, start_line, end_line)
            puts "Showing from line #{start_line} to #{end_line}"
          end

          string = Helper.strip_indentation(string)
          string = Helper.syntax_highlith(string, path) if self.ansi_output?
          string = Helper.add_line_numbers(string, start_line, line) if @number_lines

          puts
          puts string
        else
          puts "[!] File not found"
        end
      end
    end

  end
end
