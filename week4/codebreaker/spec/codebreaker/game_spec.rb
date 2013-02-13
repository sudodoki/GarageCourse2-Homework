require "spec_helper.rb"

module Codebreaker
  describe Game do
    let(:output) { double('output').as_null_object }
    let(:game) { Game.new(output) }
    context 'while initialize step' do
      it 'should generate valid code' do
        game.send :generate_code
        game.code.length.should eq(4)
        game.code.join.scan(/[0-6]{4}/)[0].length.should eq(4)
      end
    end

    describe '#start' do
      it 'sends a welcome message' do
        output.should_receive(:puts).with('welcome to Codebreaker!')
        game.stub(:prompt).as_null_object
        game.start
      end
      it 'prompts for the first guess' do
        output.should_receive(:puts).with('Enter guess:')
        game.stub(:gets).and_return("")
        game.start         
      end
    end

    context 'after getting prompt' do
      describe 'should compare input with code' do
        let(:fake_code) {Array('1'..'4')}
        context "in case it's the same " do
          it 'puts You have won the game' do
            game.stub(:prompt).as_null_object
            output.should_receive(:puts).with('You have won the game')
            game.check('1234', fake_code)
          end
          it 'starts new game' do
            game.should_receive(:start)
            game.check('1234', fake_code)
          end
        end
        context "in case it's differs " do
          it 'puts the mark out' do
            output.should_receive(:puts).with('----')
            game.check('4321', fake_code)
          end
          it 'puts the mark out' do
            output.should_receive(:puts).with('-+')
            game.check('5364', fake_code)
          end

        end

      end
    end


  end
end