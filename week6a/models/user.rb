
class User
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b)
    end
  end
  
  include DataMapper::Resource
  attr_accessor :password_confirmation
  property :id,         Serial
  property :name,       String, :key => true
  property :password,   String
  property :ip      ,   String
  property :updated_at, DateTime
  
  validates_uniqueness_of :name
  validates_confirmation_of :password
end
