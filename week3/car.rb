class Car
  # responding to setter and getter-setter methods
  ATTRIBUTES_ALLOWED = %w(engine size turbo)
  def method_missing(method, *args)
    if ATTRIBUTES_ALLOWED.include? method or ATTRIBUTES_ALLOWED.include? method.to_s.sub('=','')
      if args.empty?
        instance_variable_get("@#{method}")
      else
        attribute = {method.to_s.sub('=', '').to_sym => args[0] }
        self.set attribute  
      end
    else
      super
    end
  end

  def initialize attributes = {}, &block
    if block_given?
      instance_eval &block
    else
      set attributes
    end  
  end
   
  def set attributes
     attributes.each {|key, value| instance_variable_set("@#{key}", value)}     
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
