require File.dirname(__FILE__) + '/../test_helper'

class StatusTest < Test::Unit::TestCase
  fixtures :statuses

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  #value required
  def test_create_status
      @status = Status.new
      assert_invalid @status, :value
  end
  
  #new status
  def test_create_new_status
      @status = Status.new(:id => 3, :value => "Inactive")
      assert @status.save
      assert_valid @status
      assert_equal(4, Status.count)
  end
  
  #test for uniqueness of value
  def test_uniqueness_for_value
    status1 = Status.new(:id => 3, :value => "Inactive")
    assert_equal(true,status1.save)
    status2 = Status.new(:id => 4, :value => "Inactive")
    assert_equal(false,status2.save)
  end
   
end
