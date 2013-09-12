class CptCode < ActiveRecord::Base
  validates_length_of :code, :is => 5, :on => :create, :message => "CPT/HCPCS code must be at least {{count}} characters"
  validates_uniqueness_of :code, :on => :create, :message => "must be unique"
  validates_presence_of :description, :on => :create, :message => "can't be blank"
end
