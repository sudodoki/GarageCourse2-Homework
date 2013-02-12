=begin
  Таски : 
  #1. Дана строка слов, разделёных пробелами. Вывести длиннейшее слово.

  #2. Дан текст. Найдите все URL адреса и вычлените из них ссылку на корневую страницу сайта (например, из http://rubygarage.org/course.html сделайте http://rubygarage.org).

  #3. Дан текст. Найдите наибольшее количество идущих подряд цифр в нем.

  #4. Дан текст. Необходимо подсчитать, сколько раз встречается каждое слово в тексте.
=end

taskinput = <<-taskinput
  But I must 1 explain to you 3444 how all http://www.ukr.net/news/politika.html this 
  mistaken idea of denouncing pleasure and praising pain was born and I will give you 
  a complete account of the system, and expound the actual teachings of the great 444 
  explorer of the truth, the master-builder of 11134 human happiness. No one rejects, 
  dislikes, or avoids pleasure itself, because it is pleasure, but because those who 
  do not know 0 how to pursue 334 pleasure rationally encounter consequences that are 
  111 extremely painful. Nor again 2 is there anyone who loves or pursues or desires 
  to obtain pain of itself, because it is pain, but because occasionally circumstance  
  occur in which 3444 toil and pain can procure him some great 234.234 234 pleasure. 
  http://www.teletrade.com.ua/novice/promo?utm_source=ukr&utm_medium=kak&utm_campaign=silki 
  to take a trivial example, which of us ever undertakes laborious physical exercise, 
  http://orakul.com/horoscope/astro/general/today/lion.html except to obtain 11 some 
  advantage from it? But who has any right to find fault with a man who chooses to 
  enjoy a pleasure 312 that has 7771231, no annoying consequences, or one who avoids a pain 
  that produces no resultant pleasure?
taskinput

class Object
  def try(method)
    send method if respond_to? method
  end
end

module Utils
  module Text
    # getting array of longenst words
    def longest_words(including_non_words = false)
      if including_non_words
        words = self.split(/\W+/)
      else
        words = self.split(/\W+/).reject do |word| 
          word[/[a-zA-Z]+/].try(:length) != word.length
        end  
      end
      words.group_by(&:size).max[1]
    end
    # getting array of urls from text
    def get_urls(roots = true)
      possible_urls = self.split(/[\s,]+/)
      if roots
        possible_urls.map {|word| word[/http:\/\/(\w+\.{0,1})+/]}.compact
      else
        possible_urls.select {|word| word[/http:\/((\/|\.)\w+)+/]}
      end
    end
    # getting array of longest numbers
    def longest_number
      # only dot as delimeter is allowed, 
      # no zero ommiting with float point number is allowed too
      self.gsub(/[^\d\.]+/,' ').gsub(/\s\./, ' ').split(/[\s,]+/).group_by(&:size).max[1]
    end

    def word_map
      result = (words = self.split(/[\s,]+/)).inject({}) do |memo, word_to_find|
        memo[word_to_find] = words.count(word_to_find) if word_to_find.length > 0
        memo
      end
      result
    end

  end
end

taskinput.extend Utils::Text 
# 1.
p taskinput.longest_words
# => ["consequences", "occasionally", "circumstance", "consequences"]
# 2.
p taskinput.get_urls
# => ["http://www.ukr.net", "http://www.teletrade.com.ua", "http://orakul.com"]
# 3
p taskinput.longest_number
# => ["234.234", "7771231"]
# 4
p taskinput.word_map
# => {"But"=>2, "I"=>2, "must"=>1, "1"=>1, "explain"=>1, "to"=>7, "you"=>2, "3444"=>2, "how"=>2, "all"=>1, "http://www.ukr.net/news/politika.html"=>1, "this"=>1, "mistaken"=>1, "idea"=>1, "of"=>7, "denouncing"=>1, "pleasure"=>5, "and"=>4, "praising"=>1, "pain"=>5, "was"=>1, "born"=>1, "will"=>1, "give"=>1, "a"=>5, "complete"=>1, "account"=>1, "the"=>5, "system"=>1, "expound"=>1, "actual"=>1, "teachings"=>1, "great"=>2, "444"=>1, "explorer"=>1, "truth"=>1, "master-builder"=>1, "11134"=>1, "human"=>1, "happiness."=>1, "No"=>1, "one"=>2, "rejects"=>1, "dislikes"=>1, "or"=>4, "avoids"=>2, "itself"=>2, "because"=>4, "it"=>2, "is"=>3, "but"=>2, "those"=>1, "who"=>5, "do"=>1, "not"=>1, "know"=>1, "0"=>1, "pursue"=>1, "334"=>1, "rationally"=>1, "encounter"=>1, "consequences"=>2, "that"=>3, "are"=>1, "111"=>1, "extremely"=>1, "painful."=>1, "Nor"=>1, "again"=>1, "2"=>1, "there"=>1, "anyone"=>1, "loves"=>1, "pursues"=>1, "desires"=>1, "obtain"=>2, "occasionally"=>1, "circumstance"=>1, "occur"=>1, "in"=>1, "which"=>2, "toil"=>1, "can"=>1, "procure"=>1, "him"=>1, "some"=>2, "234.234"=>1, "234"=>1, "pleasure."=>1, "http://www.teletrade.com.ua/novice/promo?utm_source=ukr&utm_medium=kak&utm_campaign=silki"=>1, "take"=>1, "trivial"=>1, "example"=>1, "us"=>1, "ever"=>1, "undertakes"=>1, "laborious"=>1, "physical"=>1, "exercise"=>1, "http://orakul.com/horoscope/astro/general/today/lion.html"=>1, "except"=>1, "11"=>1, "advantage"=>1, "from"=>1, "it?"=>1, "has"=>2, "any"=>1, "right"=>1, "find"=>1, "fault"=>1, "with"=>1, "man"=>1, "chooses"=>1, "enjoy"=>1, "312"=>1, "7771231"=>1, "no"=>2, "annoying"=>1, "produces"=>1, "resultant"=>1, "pleasure?"=>1}