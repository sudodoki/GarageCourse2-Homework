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
        before(:each) do
          game.stub(:get_tries).and_return(1000)
        end 
        context "in case it's 'e'" do
          it 'should exit' do
            game.stub(:exit).as_null_object
            game.stub(:gets).and_return('e', '')
            game.should_receive(:exit)
            game.start
          end
        end
        context "in case it's 'h'" do
          it 'should give out the hint' do
            game.stub(:gets).and_return('h', '')
            output.should_receive(:puts).with(/(welcome to Codebreaker!|Enter guess:|[123456])/)
            game.start
          end
        end
        context "in case it's the same " do
          it 'puts You have won the game' do
            game.stub(:prompt).as_null_object
            output.should_receive(:puts).with('You have won the game')
            game.check('1234', fake_code)
          end
          it 'should ask for player\'s name' do
            game.stub(:prompt).as_null_object
            output.should_receive(:puts).with("What's your name, oh the wise one?")
            game.check('1234', fake_code)
          end
          describe 'should checkout highscore file' do
            it 'creates one if none present' do
              File.delete('highscore')
              game.check('1234', fake_code)
              File.exists?('highscore').should be true
            end
            it 'and read the highscore' do
              File.open('highscore', 'w+')  { |file| file.write("13") }
              output.should_receive(:print).with("Current highscore was 13")
              game.check('1234', fake_code)              
            end
          end
          context 'if you suck' do
            it 'should say so' do
              game.should_receive(:get_tries).and_return(10000)
              output.should_receive(:print).with("You suck. \n")
              game.check('1234', fake_code)
            end            
          end
          context 'if you rule' do
            it 'should say so' do
              game.should_receive(:get_tries).and_return(1)
              output.should_receive(:print).with("You rule, maaaan.\n")
              game.check('1234', fake_code)
            end
          end
          
          it 'starts new game' do
            game.should_receive(:start)
            game.check('1234', fake_code)
          end
        end
        context "in case it's differs " do
          it 'puts the mark out, case1' do
            output.should_receive(:puts).with('----')
            game.check('4321', fake_code)
          end
          it 'puts the mark out, case2' do
            output.should_receive(:puts).with('-+')
            game.check('5364', fake_code)
          end

        end

      end
    end


  end
end