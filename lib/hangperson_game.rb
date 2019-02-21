class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(char)
    is_abc = (char =~ /^[A-Z]$/i)
    throw ArgumentError unless is_abc
    regex = Regexp.new(char.downcase)
    letters_guessed = @guesses + @wrong_guesses
    if (letters_guessed =~ regex)
      return false
    end
    if (@word =~ regex)
      @guesses.concat(char)
    else
      @wrong_guesses.concat(char)
    end
    return true
  end
  
  def word_with_guesses
    regex = (guesses.empty?) ? /[a-z]/i : Regexp.new("[^" + @guesses + "]")
    return @word.gsub(regex, "-" )
  end
  
  def check_win_or_lose
    return :win if @word.eql?(word_with_guesses())
    return :lose if ((@guesses.length + @wrong_guesses.length) >= 7)
    return :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
