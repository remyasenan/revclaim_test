class Payergroup < ActiveRecord::Base
   validates_uniqueness_of :payergroupname
   has_many :jobs
   has_many:batches
end
