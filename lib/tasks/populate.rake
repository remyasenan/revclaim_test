namespace :db do
  desc "sss"
  task :populate => :environment do
   #~ Remittor.create(:login=>"admin", :email=> 'admin@revenuemed.com',  :password => 'revadmin' , :password_confirmation => 'revadmin')
   #~ Remittor.create(:login=>"processsor", :email=> 'proc@revenuemed.com',  :password => 'revproc' , :password_confirmation => 'revproc')    
   #~ Remittor.create(:login=>"supervisor", :email=> 'super@revenuemed.com',  :password => 'revsuper' , :password_confirmation => 'revsuper')
    #~ Remittor.create(:login=>"qaadmin", :email=> 'quality@revenuemed.com',  :password => 'revqaadmin' , :password_confirmation => 'revqaadmin')
     
     
    j=1
    for i in 1..375 do
       j+=1
      RemittorsRole.create(:remittor_id=> i,:role_id=>j)
      
      if(j==4)
        j=1
      end
    end
    
  end
end
