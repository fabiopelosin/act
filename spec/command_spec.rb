require File.expand_path('../spec_helper', __FILE__)

module Act
  describe Command do
    describe 'In general' do
      it 'runs without exceptions' do
        argv = [__FILE__]
        should.not.raise do
          Act::Command.run(argv)
        end
      end
    end
  end
end
