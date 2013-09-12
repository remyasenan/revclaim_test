class Role < ActiveRecord::Base
 has_many :remittors
has_many :remittors, :through => :remittors_roles
  has_many :remittors_roles
     validates_presence_of :name
  def to_s
    self.name
  end
  
  def self.[](key)
    self.find_by_name(key)
  end
  
  
end