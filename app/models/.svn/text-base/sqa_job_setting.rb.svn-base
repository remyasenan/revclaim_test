class SqaJobSetting < ActiveRecord::Base
    validates_presence_of :value
    validates_numericality_of :value
    validates_inclusion_of :value, :in => 1..50, :message => "Must be in between 1 & 50"
end
