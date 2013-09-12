class CreateDefaultPayer < ActiveRecord::Migration
  def self.up
     Payer.delete_all # Drop any preexisting facility entries
    payer_list = [{:gateway => "ans", :payid => "Default Payer", :payer => "Vestica"}]
   payer_list.each do |c|
      payer = Payer.new(c)
      payer.save
    end    
  end

  def self.down
    Payer.delete_all
  end
end
