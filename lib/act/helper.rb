require 'colored'
require 'active_support/core_ext/string/strip'
require 'open3'

module Act
  module Helper


    FileInformation = Struct.new(:path, :from_line, :to_line)

    def self.parse_file_information(string)
    end

    # @return [String]
    #
    def self.open_in_editor_command(path, line)
      editor = ENV['EDITOR']
      result = "#{editor} #{path}"
      if line
        case editor
        when 'vim', 'mvim'
          result = "#{editor} #{path} +#{line}"
        end
      end
      result
    end

    # @return [Fixnum]
    #
    def self.start_line(string, line, context_lines)
      start_line = line - context_lines - 1
    end

    # @return [Fixnum]
    #
    def self.end_line(string, line, context_lines)
      end_line = line + context_lines - 1
    end

    # @return [String]
    #
    def self.select_lines(string, start_line, end_line)
      string.lines[start_line..end_line].join
    end

    # @return [String]
    #
    def self.strip_indentation(string)
      string.strip_heredoc
    end

    # @return [String]
    #
    def self.add_line_numbers(string, start_line, highlight_line = nil)
      line_count = start_line
      numbered_lines = string.lines.map do |line|
        line_count += 1
        number = line_count.to_s.ljust(3)
        if highlight_line && highlight_line == line_count
          number = number.yellow
        end
        "#{number}  #{line}"
      end
      numbered_lines.join
    end

    # @return [String]
    #
    def self.syntax_highlith(string, file_name)
      return string if `which gen_bridge_metadata`.strip.empty?
      result = nil
      lexer = `pygmentize -N #{file_name}`.chomp
      Open3.popen3("pygmentize -l #{lexer}") do |stdin, stdout, stderr|
        stdin.write(string)
        stdin.close_write
        result = stdout.read
      end
      result
    end
  end
end

