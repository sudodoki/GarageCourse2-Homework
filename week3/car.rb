class Car
  # creating setter and getter-setter methods next 
  (ATTRIBUTES_ALLOWED = %w(engine size turbo)).each do |attr| 
    attr_writer attr
    define_method attr do |value = nil|
      if value.nil?
        instance_variable_get("@#{attr}")
      else
        set attr => value
      end
    end
  end

  def initialize attributes = {}, &block
    if block_given?
      self.instance_eval &block
    else
      self.set attributes
    end  
  end
   
  def set attributes
    attributes.each do |key, value|
        send "#{key}=", value 
    end
    rescue
      print "LOL U FAG U DID SOMETHING WRONG WITH #{attributes.inspect} \n"        
  end

  def engine_info
    print (if turbo
      "Turbo #{engine} engine #{size.to_f} \n"
    else  
      "#{size.to_f} #{engine.capitalize} engine \n"
    end)
  end
end
