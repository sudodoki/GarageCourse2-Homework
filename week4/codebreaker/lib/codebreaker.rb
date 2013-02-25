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
      @tries = @tries? @tries + 1 : 0
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
      @output.puts "What's your name, oh the wise one?"
      username = gets.chomp
      File.new('highscore', 'w+') unless File.exists?('highscore')
      highscore = File.open("highscore", 'a+') do |f|
        begin
          Integer(f.read) 
        rescue 
          9999
        end 
      end
      @output.print "Current highscore was #{highscore}"
      @output.print ", and you scored: #{get_tries}, using #{@shown || 0} number of hints."
      result = (get_tries > highscore) ? "You suck. \n" : "You rule, maaaan.\n"
      @output.print result
      File.open("highscore", 'w+'){|f| f.write get_tries} if get_tries < highscore 
      @shown = 0
      @tries = nil
      start
    end

    private
    def generate_code
      @code = Array('1'..'6').sample(4)
    end

    def get_tries
      @tries
    end
  end
end
Codebreaker::Game.new.start
