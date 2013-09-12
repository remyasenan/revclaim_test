class AddIncompleteStatusToProcessorStatusTable < ActiveRecord::Migration
  def change
	ProcessorStatus.create!(:name => 'Processor Incomplete')
  end
end
