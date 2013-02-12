=begin
Задание:
1. вызов метода должен печатать соот. день недели
today #=> monday or tuesday or etc
2. class A
 def to_modify
   puts "print from not modified method"
 end
end
A.new.to_modify #=> "print from not modified method"
modify( A ) #=> it should modify class A to this
A.new.to_modify #=> "print from modified method, yeah!!!"  
=end

# 1
require "date"
def today
  day_name = Date.today.strftime('%A')
  puts "Today is glorious day of #{day_name}"
end

today 

# 2
class A
  def to_modify
    puts "print from not modified method"
  end
end

def modify( class_name )
  if class_name.new.respond_to? :to_modify
    class_name.send :define_method, :to_modify do
      puts "print from modified method, yeah!!!"
    end 
  end
end

A.new.to_modify
modify A
A.new.to_modify



