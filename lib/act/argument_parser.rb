module Act
  module ArgumentParser

    FileInformation = Struct.new(:path, :from_line, :to_line, :highlight_line)

    # @return [FileInformation]
    #
    def self.parse_file_information(file, context_lines = nil)
      if file && file != ''
        if file =~ /:/
          components = file.split(':')
          path = components[0]
          line = components[1]

          if line
            if line =~ /^\d+$/
              highlight_line = line.to_i
              from_line = highlight_line - context_lines
              to_line = highlight_line + context_lines
            elsif line =~ /^\d+-\d+$/
              line_components = line.split('-')
              from_line = line_components[0].to_i
              to_line = line_components[1].to_i
            elsif line =~ /^\d+\+\d+$/
              line_components = line.split('+')
              highlight_line = line_components[0].to_i
              context = line_components[1].to_i
              from_line = highlight_line - context
              to_line = highlight_line + context
            else
              UI.warn "Unable to parse line data"
            end
          end
        elsif file =~ /#/
          components = file.split('#')
          path = components[0]
          line = components[1]

          if line
            if line =~ /^L\d+$/
              highlight_line = line[1..-1].to_i
              from_line = highlight_line - context_lines
              to_line = highlight_line + context_lines
            elsif line =~ /^L\d+-L\d+$/
              line_components = line.split('-')
              from_line = line_components[0][1..-1].to_i
              to_line = line_components[1][1..-1].to_i
            else
              UI.warn "Unable to parse line data"
            end
          end
        else
          path = file
        end

        result = FileInformation.new
        result.path = path
        result.from_line = from_line
        result.to_line = to_line
        result.highlight_line = highlight_line
        result
      end
    end

  end
end


