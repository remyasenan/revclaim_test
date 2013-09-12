class ChangeDefaultValueOfProcessorComments < ActiveRecord::Migration
  def up
    change_column_default(:jobs, :processor_comments, nil)

     #To change the existing DB values of processor_comments as nil. But it will change all the values as nil

    Job.scoped.each do |j|
        if j.processor_comments == 'null'
          j.processor_comments = nil
        end
      j.save
      end
  end

  def down
    change_column_default(:jobs, :processor_comments, "null")
  end
end
