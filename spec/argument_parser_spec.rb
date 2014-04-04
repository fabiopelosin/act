require File.expand_path('../spec_helper', __FILE__)

module Act
  describe ArgumentParser do

    before do
      @subject = ArgumentParser
    end

    #-------------------------------------------------------------------------#

    describe 'parse_file_information' do

      it 'handles paths' do
        file = 'lib/act/command.rb'
        context_lines = 5
        result = @subject.parse_file_information(file)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should.be.nil
        result.to_line.should.be.nil
        result.highlight_line.should.be.nil
      end

      it 'returns nil if no file information has been provided' do
        file = nil
        result = @subject.parse_file_information(file)
        result.should.be.nil
      end

      it 'handles paths where the line number is specified by a colon' do
        file = 'lib/act/command.rb:10'
        context_lines = 5
        result = @subject.parse_file_information(file, context_lines)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should == 5
        result.to_line.should == 15
        result.highlight_line.should == 10
      end

      it 'handles paths which include the column number' do
        file = 'lib/act/command.rb:10:2'
        context_lines = 5
        result = @subject.parse_file_information(file, context_lines)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should == 5
        result.to_line.should == 15
        result.highlight_line.should == 10
      end

      it 'handles line ranges' do
        file = 'lib/act/command.rb:10-12'
        context_lines = 5
        result = @subject.parse_file_information(file, context_lines)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should == 10
        result.to_line.should == 12
        result.highlight_line.should.be.nil
      end

      it 'handles the specification of a custom context' do
        file = 'lib/act/command.rb:10+2'
        context_lines = 5
        result = @subject.parse_file_information(file, context_lines)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should == 8
        result.to_line.should == 12
        result.highlight_line.should == 10
      end

      it 'supports GitHub style line specification' do
        file = 'lib/act/command.rb#L10'
        context_lines = 5
        result = @subject.parse_file_information(file, context_lines)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should == 5
        result.to_line.should == 15
        result.highlight_line.should == 10
      end

      it 'supports GitHub style line specification' do
        file = 'lib/act/command.rb#L10-L12'
        result = @subject.parse_file_information(file)
        result.path.should == 'lib/act/command.rb'
        result.from_line.should == 10
        result.to_line.should == 12
        result.highlight_line.should.be.nil
      end

    end

    #-------------------------------------------------------------------------#

  end
end
