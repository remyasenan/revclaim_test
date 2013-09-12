class RemittorsRole < ActiveRecord::Base
  belongs_to :remittor
  belongs_to :role
  def self.is_role(remittorid)
    role = RemittorsRole.find_by_remittor_id(remittorid).role_id
    user_role = Role.find(role).name
       
   
    return user_role
    
  end
end
