require_relative 'codebreaker/version'


module Codebreaker
  class Game
    attr_reader :code

    def initialize(output = STDOUT)
      @output = output
    end

    def start
      generate_code
      @output.puts 'welcome to Codebreaker!'
      prompt
    end

    def prompt
      @output.puts 'Enter guess:'
      answer = gets.chomp
      case answer
        when 'h'
          do_hint
        when 'e'
          exit
        else
          check(answer)
      end 
      prompt unless answer.nil? or answer == ""
    end

    def do_hint
      @shown = @shown ? @shown + 1 : 1
      @output.puts(@code.first(@shown).join)
    end

    def check(answer, code = @code)
      if answer == code.join
        congrat
      else
        marks = ''
        code.each_with_index do |digit, real_index|
          mark = '-' unless answer.index(digit).nil?
          mark = '+' if not (answer.index(digit).nil?) and answer.index(digit) == real_index
          marks << mark if mark
        end
        @output.puts marks
      end
      marks
    end

    def congrat
      @output.puts 'You have won the game'
      @shown = 0
      start
    end

    private
    def generate_code
      @code = Array('1'..'6').sample(4)
    end
  end
end
# Codebreaker::Game.new.start
