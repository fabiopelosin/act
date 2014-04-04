require 'colored'
require 'claide'
require 'active_support/core_ext/string/strip'

module Act
  class Command < CLAide::Command
    self.command = 'act'
    self.description = 'Act the command line tool to act on files'

    def self.options
      [
        ['--open', 'Open the file in $EDITOR instead of printing it'],
        ['--no-line-numbers', 'Show output without line numbers'],
        ['--version', 'Show the version of Act'],
      ].concat(super)
    end

    def self.run(argv)
      argv = CLAide::ARGV.new(argv)
      if argv.flag?('version')
        UI.puts VERSION
        exit 0
      end
      super(argv)
    end

    def initialize(argv)
      @open = argv.flag?('open')
      @number_lines = argv.flag?('line-numbers', true)
      @file_string = argv.shift_argument
      super
    end

    def validate!
      super
      help! 'A file is required.' unless @file_string
    end

    CONTEXT_LINES = 5

    def run
      clean_file_string = pre_process_file_string(@file_string)
      file = ArgumentParser.parse_file_information(clean_file_string, CONTEXT_LINES)

      path_exists = File.exist?(file.path)
      unless path_exists
        inferred = infer_local_path(file.path)
        file.path = inferred
        path_exists = true if inferred
      end

      if path_exists
        if @open
          open_file(file)
        else
          cat_file(file)
        end
      else
        UI.warn '[!] File not found'
      end
    end

    # @return [String]
    #
    def pre_process_file_string(string)
      string.sub(/https?:\/\//, '')
    end

    # @return [String, Nil]
    #
    def infer_local_path(path)
      path_components = Pathname(path).each_filename.to_a
      until path_components.empty?
        path_components.shift
        candidate = File.join(path_components)
        if File.exist?(candidate)
          return candidate
        end
      end
    end

    # @return [void]
    #
    def open_file(file)
      line = file.highlight_line || file.from_line
      command = Helper.open_in_editor_command(file.path, line)
      UI.puts command if self.verbose?
      system(command)
    end

    # @return [void]
    #
    def cat_file(file)
      string = File.read(file.path)
      if file.from_line && file.to_line
        string = Helper.select_lines(string, file.from_line, file.to_line)
      end

      if string
        string = Helper.strip_indentation(string)
        string = Helper.syntax_highlith(string, file.path) if self.ansi_output?
        string = Helper.add_line_numbers(string, file.from_line, file.highlight_line) if @number_lines
        UI.puts "\nstring"
      else
        UI.warn '[!] Nothing to show'
      end
    end
  end
end
