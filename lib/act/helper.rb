require 'colored'
require 'active_support/core_ext/string/strip'
require 'open3'
require 'rouge'

module Act
  module Helper
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

    # @return [String, Nil]
    #
    def self.select_lines(string, start_line, end_line)
      start_line = start_line - 1
      end_line = end_line - 1
      start_line = 0 if start_line < 0
      end_line = 0 if end_line < 0
      components = string.lines[start_line..end_line]
      components.join if components && !components.empty?
    end

    # @return [String]
    #
    def self.strip_indentation(string)
      string.strip_heredoc
    end

    # @return [String]
    #
    def self.add_line_numbers(string, start_line, highlight_line = nil)
      start_line ||= 1
      line_count = start_line
      numbered_lines = string.lines.map do |line|
        number = line_count.to_s.ljust(3)
        if highlight_line && highlight_line == line_count
          number = number.yellow
        end
        line_count += 1
        "#{number}  #{line}"
      end
      numbered_lines.join
    end

    def self.lexer(file_name, string = nil)
      if string
        Rouge::Lexer.guess(:filename => file_name, :source => string).tag
      else
        Rouge::Lexer.guess_by_filename(file_name).tag
      end
    end

    def self.prettify(string, lexer)
      raise ArgumentError unless string
      raise ArgumentError unless lexer
      case lexer
      when 'json'
        require 'json'
        JSON.pretty_generate(JSON.parse(string))
      when 'xml'
        require 'rexml/document'
        doc = REXML::Document.new(string)
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        ''.tap do |s|
          formatter.write(doc, s)
        end
      else
        string
      end
    end

    # @return [String]
    #
    def self.syntax_highlight(string, lexer)
      formatter = Rouge::Formatters::Terminal256.new(:theme => 'monokai')
      Rouge.highlight(string, lexer, formatter)
    end

  end
end
