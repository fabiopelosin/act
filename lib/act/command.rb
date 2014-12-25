require 'colored'
require 'claide'
require 'active_support/core_ext/string/strip'

module Act
  class Command < CLAide::Command
    self.command = 'act'

    self.description = <<-DOC
      Act the command line tool to act on files

      Prints the contents of the file at `PATH`.

    DOC

    def self.arguments
      [
        CLAide::Argument.new('PATH', false),
      ]
    end

    def self.options
      [
        ['--open', 'Open the file in $EDITOR instead of printing it'],
        ['--prettify', 'Prettify output'],
        ['--always-color', 'Always color the output'],
        ['--line-numbers', 'Show output with line numbers'],
        ['--lexer=NAME', 'Use the given lexer'],
      ].concat(super)
    end

    def self.completion_description
      description = super
      # _path_files function
      description[:paths] = :all_files
      description
    end

    def initialize(argv)
      @stdin = STDIN.read unless STDIN.tty?
      @open = argv.flag?('open')
      @prettify = argv.flag?('prettify', false)
      @number_lines = argv.flag?('line-numbers', false)
      @lexer = argv.option('lexer', false)
      @always_color = argv.flag?('always-color')
      @file_string = argv.shift_argument
      super
    end

    def validate!
      super
      help! 'A file is required.' unless @file_string || @open || @stdin
    end

    CONTEXT_LINES = 5

    def run
      if @stdin && !@open
        cat_string(@stdin)
        return
      end


      @file_string ||= '.'
      clean_file_string = pre_process_file_string(@file_string)
      file = ArgumentParser.parse_file_information(clean_file_string, CONTEXT_LINES)

      path_exists = File.exist?(file.path)
      unless path_exists
        inferred = infer_local_path(file.path)
        if inferred
          file.path = inferred
          path_exists = true
        end
      end

      if @open
        open_file(file)
      else
        if path_exists
          cat_file(file)
        else
          UI.warn '[!] File not found'
        end
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
      if defined? Bundler
        Bundler.with_clean_env do
          system(command)
        end
      else
        system(command)
      end
    end

    # @return [void]
    #
    def cat_file(file)
      string = File.read(file.path)
      if file.from_line && file.to_line
        string = Helper.select_lines(string, file.from_line, file.to_line)
      end
      cat_string(string, file)
    end

    def cat_string(string, file = nil)
      if string
        path = file.path if file
        @lexer ||= Helper.lexer(path, string)
        string = Helper.strip_indentation(string)
        string = Helper.prettify(string, @lexer) if @prettify
        string = Helper.syntax_highlight(string, @lexer) if ansi_output? || @always_color
        string = Helper.add_line_numbers(string, file.from_line, file.highlight_line) if @number_lines && file
        UI.puts UI.tty? ? "\n#{string}" : string
      else
        UI.warn '[!] Nothing to show'
      end
    end
  end
end
