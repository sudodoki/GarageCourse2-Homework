class Car
  # responding to setter and getter-setter methods
  ATTRIBUTES_ALLOWED = %w(engine size turbo)
  def method_missing(method, *args)    
    method_name = method.to_s.sub('=','')
    if ATTRIBUTES_ALLOWED.include?(method_name)
      if args.empty?
        instance_variable_get("@#{method_name}")
      else
        attribute = {method_name.to_sym => args[0] }        
        set attribute  
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
     attributes.each do |key, value| 
      if ATTRIBUTES_ALLOWED.include? key.to_s 
        instance_variable_set("@#{key}", value)
      else
        raise
      end
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

