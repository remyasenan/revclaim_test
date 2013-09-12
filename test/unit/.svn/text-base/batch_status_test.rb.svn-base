require File.dirname(__FILE__) + '/../test_helper'

class BatchStatusTest < Test::Unit::TestCase
  fixtures :batch_statuses
  
  def test_to_s
    status = batch_statuses(:bs2)
    assert_equal status.name, status.to_s
  end
end
