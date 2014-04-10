require File.expand_path('../spec_helper', __FILE__)

module Act
  describe Helper do

    before do
      @subject = Helper
    end

    #-------------------------------------------------------------------------#

    describe 'select_lines' do

      it 'returns the lines corresponding to the given range' do
        string = "1\n2\n3\n4"
        result = @subject.select_lines(string, 1, 2)
        result.should == "1\n2\n"
      end

      it 'use a one-based index' do
        string = "index\nanother"
        result = @subject.select_lines(string, 1, 1)
        result.should == "index\n"
      end

      it 'returns nil if the range is malformed' do
        string = "1\n2\n3\n4"
        result = @subject.select_lines(string, 2, 1)
        result.should.nil
      end

      it 'returns nil if the range is outside the lines of the string' do
        string = "1\n2\n3\n4"
        result = @subject.select_lines(string, 10, 11)
        result.should.nil
      end

      it 'returns the matched part if the range is partially outside the lines of the string' do
        string = "1\n2\n3\n4"
        result = @subject.select_lines(string, 3, 10)
        result.should == "3\n4"
      end

      it 'handles negative line numbers' do
        string = "1\n2\n3\n4"
        result = @subject.select_lines(string, -2, 2)
        result.should == "1\n2\n"
      end

    end

    #-------------------------------------------------------------------------#

    describe 'lexer' do
      it 'infers the lexer according to the extension using pygmentize' do
        file_name = 'test.rb'
        result = @subject.lexer(file_name)
        result.should == 'rb'
      end

      it 'infers the lexer according to the file name' do
        file_name = 'Gemfile'
        result = @subject.lexer(file_name)
        result.should == 'rb'
      end
    end

    #-------------------------------------------------------------------------#

  end
end
